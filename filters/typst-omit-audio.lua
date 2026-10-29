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

  -- Sanitize unpopulated placeholder attributes
  if img.attributes["width"] == "value" then
    img.attributes["width"] = nil
  end

  -- Scale portrait book covers and tall posters to a balanced, proportional size
  local cap_text = pandoc.utils.stringify(img.caption)
  if img.src:match("2%.1%.1") or img.src:match("2%.3%.1") or cap_text:match("Book cover") or img.src:match("8%.3%.3") or cap_text:match("campaign poster") then
    img.attributes["width"] = "2.1in"
  end

  return img
end

local function make_country_profile_card(title, items)
  local t = {}
  table.insert(t, '#block(\n')
  table.insert(t, '  width: 100%,\n')
  table.insert(t, '  stroke: 0.75pt + rgb("#cbd5e1"),\n')
  table.insert(t, '  radius: 6pt,\n')
  table.insert(t, '  clip: true,\n')
  table.insert(t, '  fill: rgb("#fcfbf9"),\n')
  table.insert(t, '  breakable: false,\n')
  table.insert(t, '  spacing: 1.5em,\n')
  table.insert(t, '  [\n')
  table.insert(t, '    #rect(\n')
  table.insert(t, '      fill: rgb("#1e3a8a"),\n')
  table.insert(t, '      width: 100%,\n')
  table.insert(t, '      inset: (x: 12pt, y: 7.5pt),\n')
  table.insert(t, '      stroke: none,\n')
  table.insert(t, '      radius: 0pt,\n')
  table.insert(t, '    )[\n')
  table.insert(t, '      #grid(\n')
  table.insert(t, '        columns: (1fr, auto),\n')
  table.insert(t, '        align: (left + horizon, right + horizon),\n')
  local banner_text = (title:upper() .. ' · COUNTRY PROFILE'):gsub('\\', '\\\\'):gsub('"', '\\"')
  table.insert(t, string.format('        text(font: font-sans, size: 8.5pt, weight: "bold", fill: white, tracking: 1.4pt, "%s"),\n', banner_text))
  table.insert(t, '        text(font: font-sans, size: 7.2pt, weight: "bold", fill: rgb("#93c5fd"), tracking: 1.2pt, "AT A GLANCE")\n')
  table.insert(t, '      )\n')
  table.insert(t, '    ]\n')
  table.insert(t, '    #pad(x: 12pt, top: 10pt, bottom: 8pt)[\n')
  table.insert(t, '      #grid(\n')
  table.insert(t, '        columns: (1fr, 1fr),\n')
  table.insert(t, '        column-gutter: 20pt,\n')
  table.insert(t, '        row-gutter: 9pt,\n')
  for _, it in ipairs(items) do
    local l = it.label:gsub('\\', '\\\\'):gsub('"', '\\"')
    local v = it.val:gsub('\\', '\\\\'):gsub('"', '\\"')
    table.insert(t, '        block(inset: (bottom: 4pt), stroke: (bottom: 0.5pt + rgb("#e2e8f0")))[\n')
    table.insert(t, string.format('          #text(font: font-sans, size: 6.8pt, weight: "bold", fill: rgb("#64748b"), tracking: 0.8pt, "%s")\n', l:upper()))
    table.insert(t, '          \\ \n')
    table.insert(t, '          #v(1.5pt)\n')
    table.insert(t, string.format('          #text(font: font-sans, size: 8.5pt, weight: "semibold", fill: rgb("#0f172a"), "%s")\n', v))
    table.insert(t, '        ],\n')
  end
  table.insert(t, '      )\n')
  table.insert(t, '    ]\n')
  table.insert(t, '  ]\n')
  table.insert(t, ')\n')
  return table.concat(t)
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
  local last_h3 = ""

  for _, block in ipairs(doc.blocks) do
    -- 0. Suppress unpopulated placeholder figures
    local is_placeholder = false
    pandoc.walk_block(block, {
      Image = function(img)
        if img.src:match("image%%20path") or img.src:match("image path") then
          is_placeholder = true
        end
      end
    })

    if is_placeholder then
      -- Omit unpopulated placeholder figures from PDF build

    -- 1. Check for Headers
    elseif block.t == "Header" then
      local h_text = pandoc.utils.stringify(block)
      if block.level == 3 then
        last_h3 = h_text
      end
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

    -- 9. Country Profile Factsheet Card (Case Studies)
    elseif block.t == "BulletList" and #block.content > 0 and pandoc.utils.stringify(block.content[1]):match("Full Country Name") then
      local title = last_h3
      local items = {}
      for _, item in ipairs(block.content) do
        local raw = pandoc.utils.stringify(item)
        local label, val = raw:match("^([^:]+):%s*(.*)$")
        if label and val then
          table.insert(items, { label = label, val = val })
          if (not title or title == "" or title == "Country") and label:match("Full Country Name") then
            local short = val:match("^([^,]+)")
            if short and short ~= "" then
              title = short
            end
          end
        end
      end
      if not title or title == "" then
        title = "Country"
      end
      local card_typst = make_country_profile_card(title, items)
      table.insert(new_blocks, pandoc.RawBlock("typst", card_typst))

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
