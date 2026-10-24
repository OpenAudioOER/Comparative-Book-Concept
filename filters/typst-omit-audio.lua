-- filters/typst-omit-audio.lua
-- Typst print-enhancements filter:
-- 1. Suppresses Spotify links and audio-timestamps
-- 2. Formats References sections with hanging indents
-- 3. Balances table column widths and uppercases table headers

function Table(tbl)
  if not quarto.doc.is_format("typst") then
    return tbl
  end

  -- Balance column widths
  if #tbl.colspecs == 5 then
    tbl.colspecs = {
      {pandoc.AlignLeft, 0.17},
      {pandoc.AlignLeft, 0.17},
      {pandoc.AlignLeft, 0.22},
      {pandoc.AlignLeft, 0.23},
      {pandoc.AlignLeft, 0.21}
    }
  elseif #tbl.colspecs == 4 then
    tbl.colspecs = {
      {pandoc.AlignLeft, 0.18},
      {pandoc.AlignLeft, 0.28},
      {pandoc.AlignLeft, 0.27},
      {pandoc.AlignLeft, 0.27}
    }
  elseif #tbl.colspecs == 2 then
    tbl.colspecs = {
      {pandoc.AlignLeft, 0.32},
      {pandoc.AlignLeft, 0.68}
    }
  end

  -- Uppercase table header row
  if tbl.head and tbl.head.rows then
    for _, row in ipairs(tbl.head.rows) do
      for _, cell in ipairs(row.cells) do
        local div = pandoc.walk_block(pandoc.Div(cell.contents), {
          Str = function(s) return pandoc.Str(s.text:upper()) end
        })
        cell.contents = div.content
      end
    end
  end

  return tbl
end

function Image(img)
  if not quarto.doc.is_format("typst") then
    return img
  end

  -- Scale portrait book covers to a balanced, proportional size
  local cap_text = pandoc.utils.stringify(img.caption)
  if img.src:match("2%.1%.1") or img.src:match("2%.3%.1") or cap_text:match("Book cover") then
    img.attributes["width"] = "2.1in"
  end

  return img
end

function Pandoc(doc)
  if not quarto.doc.is_format("typst") then
    return doc
  end

  local new_blocks = {}
  local in_references = false
  local in_key_terms = false
  local in_review_questions = false
  local in_critical_thinking = false

  for _, block in ipairs(doc.blocks) do
    -- 1. Check for Headers
    if block.t == "Header" then
      local h_text = pandoc.utils.stringify(block)
      if h_text:match("References") then
        in_references = true
      else
        in_references = false
      end
      if h_text:match("Key Terms") then
        in_key_terms = true
      elseif block.level <= 3 then
        in_key_terms = false
      end
      if h_text:match("Review Questions") then
        in_review_questions = true
      elseif block.level <= 3 then
        in_review_questions = false
      end
      if h_text:match("Critical Thinking") then
        in_critical_thinking = true
      elseif block.level <= 3 then
        in_critical_thinking = false
      end
      table.insert(new_blocks, block)

    -- 2. Suppress Spotify paragraph
    elseif block.t == "Para" and pandoc.utils.stringify(block):match("^Listen on Spotify") then
      -- Omit Spotify link paragraph

    -- 3. Suppress audio-timestamps div
    elseif block.t == "Div" and block.classes:includes("audio-timestamps") then
      -- Omit audio-timestamps div

    -- 4. Apply hanging indent to references paragraphs
    elseif in_references and block.t == "Para" then
      local open_typst = pandoc.RawBlock("typst", "#block(spacing: 1.15em)[#set par(hanging-indent: 1.5em, justify: false, leading: 0.52em)\n")
      local close_typst = pandoc.RawBlock("typst", "]\n")
      table.insert(new_blocks, open_typst)
      table.insert(new_blocks, block)
      table.insert(new_blocks, close_typst)

    -- 5. Format Key Terms as glossary entries (no bullets, hanging indent)
    elseif in_key_terms and block.t == "BulletList" then
      for _, item in ipairs(block.content) do
        local open_term = pandoc.RawBlock("typst", "#block(spacing: 0.9em)[#set par(hanging-indent: 1.5em, justify: false, leading: 0.58em)\n")
        local close_term = pandoc.RawBlock("typst", "]\n")
        table.insert(new_blocks, open_term)
        for _, sub_b in ipairs(item) do
          table.insert(new_blocks, sub_b)
        end
        table.insert(new_blocks, close_term)
      end

    -- 6. Format Review Questions as unbreakable blocks with hanging numbers
    elseif in_review_questions and block.t == "OrderedList" then
      for i, item in ipairs(block.content) do
        local open_rq = pandoc.RawBlock("typst", string.format(
          "#block(breakable: false, spacing: 1.15em)[\n" ..
          "  #grid(\n" ..
          "    columns: (1.5em, 1fr),\n" ..
          "    gutter: 0pt,\n" ..
          "    align: (top + left, top + left),\n" ..
          "    [%d.],\n" ..
          "    [\n", i
        ))
        local close_rq = pandoc.RawBlock("typst", "    ]\n  )\n]\n")
        table.insert(new_blocks, open_rq)
        for _, sub_b in ipairs(item) do
          table.insert(new_blocks, sub_b)
        end
        table.insert(new_blocks, close_rq)
      end

    -- 7. Format Critical Thinking Questions with generous spacing and hanging numbers
    elseif in_critical_thinking and block.t == "OrderedList" then
      for i, item in ipairs(block.content) do
        local open_ct = pandoc.RawBlock("typst", string.format(
          "#block(breakable: false, spacing: 1.4em)[\n" ..
          "  #grid(\n" ..
          "    columns: (1.5em, 1fr),\n" ..
          "    gutter: 0pt,\n" ..
          "    align: (top + left, top + left),\n" ..
          "    [%d.],\n" ..
          "    [\n", i
        ))
        local close_ct = pandoc.RawBlock("typst", "    ]\n  )\n]\n")
        table.insert(new_blocks, open_ct)
        for _, sub_b in ipairs(item) do
          table.insert(new_blocks, sub_b)
        end
        table.insert(new_blocks, close_ct)
      end

    -- 8. Style Answer Key box in Review Questions
    elseif block.t == "Para" and pandoc.utils.stringify(block):match("^Answers%s*:") then
      local ans_str = pandoc.utils.stringify(block):gsub("^Answers%s*:%s*", "")
      ans_str = ans_str:gsub("%s+", " ")
      local raw_typst = "#v(1.2em)\n" ..
        "#rect(\n" ..
        "  fill: rgb(\"#f8fafc\"),\n" ..
        "  stroke: 0.75pt + rgb(\"#cbd5e1\"),\n" ..
        "  radius: 4pt,\n" ..
        "  inset: (x: 12pt, y: 9pt),\n" ..
        "  width: 100%,\n" ..
        "  [\n" ..
        "    #grid(\n" ..
        "      columns: (auto, 1fr),\n" ..
        "      gutter: 14pt,\n" ..
        "      align: horizon,\n" ..
        "      [\n" ..
        "        #text(font: font-sans, size: 8pt, weight: \"bold\", fill: rgb(\"#475569\"))[ANSWER KEY]\n" ..
        "      ],\n" ..
        "      [\n" ..
        "        #text(font: font-sans, size: 9pt, weight: \"medium\", fill: rgb(\"#1e293b\"))[" .. ans_str .. "]\n" ..
        "      ]\n" ..
        "    )\n" ..
        "  ]\n" ..
        ")\n" ..
        "#v(0.6em)\n"
      local answer_box = pandoc.RawBlock("typst", raw_typst)
      table.insert(new_blocks, answer_box)

    else
      table.insert(new_blocks, block)
    end
  end

  doc.blocks = new_blocks
  return doc
end

function Div(d)
  if not quarto.doc.is_format("typst") then
    return d
  end

  -- Style callout intro text (e.g., "By the end of this section, you will be able to:")
  -- to match HTML theme's sans-serif semi-bold lead style
  if d.classes:includes("callout-note") or (d.classes:includes("callout") and not d.classes:includes("audio-timestamps")) then
    if #d.content >= 3 and d.content[2].t == "Para" and d.content[3].t == "BulletList" then
      local p_text = pandoc.utils.stringify(d.content[2])
      d.content[2] = pandoc.RawBlock("typst", string.format('#block(below: 8pt)[#text(font: font-sans, weight: "bold", size: 9.3pt, fill: brand-slate)[%s]]', p_text))
    end
  end

  return d
end

return {
  { Table = Table },
  { Image = Image },
  { Div = Div },
  { Pandoc = Pandoc }
}
