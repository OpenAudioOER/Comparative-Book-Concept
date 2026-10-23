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
  if #tbl.colspecs == 4 then
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

function Pandoc(doc)
  if not quarto.doc.is_format("typst") then
    return doc
  end

  local new_blocks = {}
  local in_references = false

  for _, block in ipairs(doc.blocks) do
    -- 1. Check for References header
    if block.t == "Header" and block.level == 2 then
      local h_text = pandoc.utils.stringify(block)
      if h_text:match("References") then
        in_references = true
      else
        in_references = false
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
      local open_typst = pandoc.RawBlock("typst", "#block(spacing: 0.9em)[#set par(hanging-indent: 1.5em, justify: false)\n")
      local close_typst = pandoc.RawBlock("typst", "]\n")
      table.insert(new_blocks, open_typst)
      table.insert(new_blocks, block)
      table.insert(new_blocks, close_typst)

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
  { Div = Div },
  { Pandoc = Pandoc }
}
