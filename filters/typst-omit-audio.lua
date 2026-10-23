-- filters/typst-omit-audio.lua
-- Typst print-enhancements filter:
-- 1. Suppresses Spotify links and audio-timestamps
-- 2. Formats References sections with hanging indents
-- 3. Balances table column widths for 4-column tables like Table 2.3.1

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

    -- 5. Balance table columns for 4-column tables
    elseif block.t == "Table" then
      if #block.colspecs == 4 then
        -- Column 1 is method label (narrower); columns 2-4 are descriptive scenarios
        block.colspecs = {
          {pandoc.AlignLeft, 0.18},
          {pandoc.AlignLeft, 0.28},
          {pandoc.AlignLeft, 0.27},
          {pandoc.AlignLeft, 0.27}
        }
      end
      table.insert(new_blocks, block)

    else
      table.insert(new_blocks, block)
    end
  end

  doc.blocks = new_blocks
  return doc
end
