// =============================================================================
// TYPST CUSTOM THEME HEADER (OpenAudio OER Textbook Theme)
// =============================================================================

#let tb-navy = rgb("1e3a8a")
#let tb-slate = rgb("1e293b")
#let tb-ink = rgb("0f172a")
#let tb-muted = rgb("64748b")
#let tb-border = rgb("cbd5e1")
#let tb-border-light = rgb("e2e8f0")
#let tb-blue-soft = rgb("eff6ff")
#let tb-blue = rgb("1d4ed8")

// -----------------------------------------------------------------------------
// Typography & Headings
// -----------------------------------------------------------------------------
#show heading: it => {
  set text(font: "Plus Jakarta Sans")
  if it.level == 1 {
    // Level 1: Chapter Opener
    v(1.5cm)
    block(width: 100%)[
      #text(fill: tb-navy, size: 10pt, weight: "bold", tracking: 1.5pt)[
        CHAPTER #counter(heading).display("1")
      ]
      #v(6pt)
      #text(fill: tb-ink, size: 22pt, weight: "bold")[
        #it.body
      ]
      #v(4pt)
      #line(length: 100%, stroke: 1.5pt + tb-navy)
    ]
    v(1.2cm)
  } else if it.level == 2 {
    // Level 2: Major Section (e.g. 1.1)
    v(1.5em)
    text(fill: tb-slate, size: 14.5pt, weight: "bold")[
      #if it.numbering != none [
        #counter(heading).display(it.numbering) #h(6pt)
      ]
      #it.body
    ]
    v(0.6em)
  } else if it.level == 3 {
    // Level 3: Subsection
    v(1.2em)
    text(fill: tb-slate, size: 12pt, weight: "bold")[
      #if it.numbering != none [
        #counter(heading).display(it.numbering) #h(5pt)
      ]
      #it.body
    ]
    v(0.5em)
  } else if it.level == 4 {
    // Level 4: Sub-subsection (e.g. Step One)
    v(1.0em)
    text(fill: tb-slate, size: 11pt, weight: "bold")[
      #it.body
    ]
    v(0.4em)
  } else {
    v(0.8em)
    text(fill: tb-slate, size: 10.5pt, weight: "bold")[
      #it.body
    ]
    v(0.4em)
  }
}

// -----------------------------------------------------------------------------
// Callout Boxes: Modern Left-Accent Card
// -----------------------------------------------------------------------------
#let callout(
  body: [],
  title: "Callout",
  background_color: rgb("#f0f7ff"),
  icon: none,
  icon_color: rgb("#1e3a8a"),
  body_background_color: rgb("#f8fbff")
) = {
  block(
    breakable: false,
    fill: background_color,
    stroke: (left: 3.5pt + icon_color, rest: 0.5pt + tb-border),
    width: 100%,
    radius: (right: 5pt, left: 0pt),
    inset: (x: 14pt, y: 11pt),
    spacing: 1.3em,
    [
      #block(below: 8pt)[
        #text(font: "Plus Jakarta Sans", weight: "bold", fill: icon_color, size: 10.5pt)[
          #if icon != none [#icon #h(5pt)]#title
        ]
      ]
      #text(font: "Source Serif 4", size: 10pt, fill: tb-ink)[
        #body
      ]
    ]
  )
}

// -----------------------------------------------------------------------------
// Tables: Academic Booktabs Style
// -----------------------------------------------------------------------------
#show table: set table(
  stroke: (x, y) => if y == 0 {
    (top: 1.5pt + tb-navy, bottom: 0.75pt + tb-navy)
  } else {
    none
  },
  fill: (col, row) => if row == 0 {
    tb-blue-soft
  } else {
    none
  },
  inset: (x: 8pt, y: 7pt)
)

// Header cells in tables use Plus Jakarta Sans Bold
#show table.cell: it => {
  if it.y == 0 {
    text(font: "Plus Jakarta Sans", weight: "bold", size: 9pt, fill: tb-slate)[#it.body]
  } else {
    text(font: "Source Serif 4", size: 9.5pt, fill: tb-ink)[#it.body]
  }
}

// -----------------------------------------------------------------------------
// Figures: Framed with Two-Tier Captions
// -----------------------------------------------------------------------------
#show figure.where(kind: image): it => {
  set align(center)
  block(
    width: 100%,
    spacing: 1.5em,
    [
      #block(
        stroke: 0.75pt + tb-border,
        radius: 4pt,
        clip: true,
        inset: 0pt,
        it.body
      )
      #if it.has("caption") [
        #v(6pt)
        #text(font: "Plus Jakarta Sans", size: 9pt, fill: tb-slate)[
          #it.caption
        ]
      ]
    ]
  )
}
