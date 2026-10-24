// =============================================================================
// OPENAUDIO OER TEXTBOOK TYPST TEMPLATE
// Introduction to Comparative Government and Politics, 2nd Edition
// =============================================================================

#let brand-navy = rgb("#1e3a8a")
#let brand-slate = rgb("#1e293b")
#let brand-ink = rgb("#0f172a")
#let brand-muted = rgb("#64748b")
#let brand-border = rgb("#cbd5e1")
#let brand-border-light = rgb("#e2e8f0")
#let brand-tint = rgb("#f0f7ff")
#let brand-header-bg = rgb("#f1f5f9")

#import "@preview/fontawesome:0.5.0": *

#let content-to-string(content) = {
  if type(content) == str {
    content
  } else if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  } else {
    ""
  }
}

#let font-sans = ("Plus Jakarta Sans", "Helvetica Neue", "Arial")
#let font-serif = ("Source Serif 4", "Charter", "Georgia")
#let font-mono = ("JetBrains Mono", "Menlo", "Courier New")

// -----------------------------------------------------------------------------
// Pandoc Helper Functions
// -----------------------------------------------------------------------------
#let horizontalrule = line(length: 100%, stroke: 0.5pt + brand-border)

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms.item: it => block(breakable: false, spacing: 0.8em)[
  #text(font: font-sans, weight: "bold", fill: brand-slate)[#it.term]\
  #block(inset: (left: 1.2em, top: 2pt))[
    #text(font: font-serif, size: 9.5pt, fill: brand-ink)[#it.description]
  ]
]

// -----------------------------------------------------------------------------
// Callout Boxes: Modern Left-Accent Card Matching HTML Theme
// -----------------------------------------------------------------------------
#let callout-info-svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"#1d4ed8\" viewBox=\"0 0 16 16\"><path d=\"M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16\"/><path d=\"m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0\"/></svg>"

#let callout(
  body: [],
  title: "Callout",
  background_color: rgb("#f0f7ff"),
  icon: none,
  icon_color: rgb("#1d4ed8"),
  body_background_color: rgb("#f8faff")
) = {
  block(
    fill: rgb("#f8faff"),
    width: 100%,
    stroke: (
      left: 4.5pt + rgb("#1d4ed8"),
      top: 0.75pt + rgb("#bfdbfe"),
      right: 0.75pt + rgb("#bfdbfe"),
      bottom: 0.75pt + rgb("#bfdbfe"),
    ),
    radius: 8pt,
    clip: true,
    spacing: 1.8em,
    breakable: false,
    [
      // Distinct Header Banner matching HTML .callout-header
      #block(
        fill: rgb("#eff6ff"),
        width: 100%,
        inset: (x: 14pt, y: 9.5pt),
        stroke: (bottom: 1pt + rgb("#bfdbfe")),
        spacing: 0pt,
        above: 0pt,
        below: 0pt,
        [
          #box(baseline: 1.2pt)[#image(bytes(callout-info-svg), format: "svg", width: 10pt, height: 10pt)]
          #h(6pt)
          #text(font: font-sans, weight: 700, fill: rgb("#1e3a8a"), size: 10.2pt)[#title]
        ]
      )
      // Card Body Area matching HTML .callout-body
      #block(
        fill: rgb("#f8faff"),
        width: 100%,
        inset: (x: 14pt, top: 12pt, bottom: 14pt),
        spacing: 0pt,
        above: 0pt,
        below: 0pt,
        [
          #set text(font: font-serif, size: 9.7pt, fill: rgb("#0f172a"))
          #set par(leading: 0.68em)
          #set list(spacing: 1.1em, marker: text(fill: rgb("#1e293b"), size: 9.5pt)[•])
          #body
        ]
      )
    ]
  )
}

#let is-first-section = state("is-first-section", true)

// -----------------------------------------------------------------------------
// Main Document Layout Rule
// -----------------------------------------------------------------------------
#let book-theme(
  title: "",
  subtitle: "",
  authors: (),
  date: none,
  doc
) = {
  // Document metadata
  set document(
    title: if type(title) == content { content-to-string(title) } else { str(title) },
    author: "Dr. Dino Bozonelos, Dr. Julia Wendt, Dr. Charlotte Lee, Jessica Scarffe, Brian Barrick, Dr. Masahiro Omae, Dr. Josh Franco, Dr. Byran Martin, and Stefan Veldhuis",
  )

  // Page geometry (US Letter)
  set page(
    paper: "us-letter",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.8cm, right: 2.4cm),
    header: context {
      let cur-phys = here().page()
      let page-num = counter(page).get().first()
      // Suppress headers on chapter start pages
      let is-chapter-start = query(heading.where(level: 1)).any(h => h.location().page() == cur-phys)
      if not is-chapter-start {
        set text(font: font-sans, size: 8.5pt, fill: brand-muted)
        if calc.odd(page-num) {
          // Odd page (Recto): Section title left, page number right
          let h2-on-page = query(heading.where(level: 2)).filter(h => h.location().page() == cur-phys)
          let section-title = if h2-on-page.len() > 0 {
            h2-on-page.first().body
          } else {
            let current-h2 = query(selector(heading.where(level: 2)).before(here()))
            if current-h2.len() > 0 { current-h2.last().body } else { title }
          }
          box(width: 100%, inset: (bottom: 4pt), stroke: (bottom: 0.5pt + brand-border-light))[
            #section-title #h(1fr) #strong(str(page-num))
          ]
        } else {
          // Even page (Verso): Page number left, Chapter title right
          let h1-on-page = query(heading.where(level: 1)).filter(h => h.location().page() == cur-phys)
          let chapter-title = if h1-on-page.len() > 0 {
            h1-on-page.first().body
          } else {
            let current-h1 = query(selector(heading.where(level: 1)).before(here()))
            if current-h1.len() > 0 { current-h1.last().body } else { title }
          }
          box(width: 100%, inset: (bottom: 4pt), stroke: (bottom: 0.5pt + brand-border-light))[
            #strong(str(page-num)) #h(1fr) #chapter-title
          ]
        }
      }
    },
    footer: context {
      let cur-phys = here().page()
      let page-num = counter(page).get().first()
      // Bottom page number only on chapter openers
      let is-chapter-start = query(heading.where(level: 1)).any(h => h.location().page() == cur-phys)
      if is-chapter-start {
        set text(font: font-sans, size: 9pt, fill: brand-muted)
        align(center)[#page-num]
      }
    }
  )

  // Typography defaults
  set text(
    font: font-serif,
    size: 10pt,
    fill: brand-ink,
    lang: "en",
  )

  set par(
    justify: true,
    leading: 0.72em,
    first-line-indent: 0pt,
    spacing: 1.1em,
  )

  // Lists
  set list(spacing: 0.9em)
  set enum(spacing: 0.9em)

  // Vocabulary / Strong text (prevent hyphenating bold words across lines)
  show strong: set text(hyphenate: false)

  // Code blocks
  show raw.where(block: true): set block(
    fill: rgb("#f8fafc"),
    stroke: 0.5pt + brand-border,
    inset: 9pt,
    radius: 4pt,
    width: 100%,
  )
  show raw: set text(font: font-mono, size: 8.8pt)

  // Links
  show link: it => {
    if it.body == [Listen on Spotify] {
      rect(
        fill: rgb("#f0fdf4"),
        stroke: 0.75pt + rgb("#16a34a"),
        radius: 4pt,
        inset: (x: 10pt, y: 6pt),
        [
          #text(font: font-sans, weight: "bold", size: 9pt, fill: rgb("#15803d"))[
            ▶ Listen to Audio Chapter on Spotify
          ]
        ]
      )
    } else {
      text(fill: brand-navy)[#it]
    }
  }

  // ---------------------------------------------------------------------------
  // Headings
  // ---------------------------------------------------------------------------
  show heading: set text(font: font-sans, hyphenate: false)

  show heading.where(level: 1): it => {
    // Level 1: Chapter Opener (Starts on a fresh page)
    is-first-section.update(true)
    pagebreak(weak: true)
    v(1.8cm)
    block(width: 100%)[
      #text(fill: brand-ink, size: 22pt, weight: "bold")[
        #it.body
      ]
      #v(6pt)
      #line(length: 100%, stroke: 1.5pt + brand-navy)
    ]
    v(1.2cm)
  }

  show heading.where(level: 2): it => {
    // Level 2: Major Section (Starts on fresh page for section 2+, sits under chapter opener for section 1)
    context {
      if not is-first-section.get() {
        pagebreak(weak: true)
      }
    }
    is-first-section.update(false)
    v(1.4em)
    text(fill: brand-slate, size: 14pt, weight: "bold")[
      #it.body
    ]
    v(0.6em)
  }

  show heading.where(level: 3): set text(fill: brand-slate, size: 11.5pt, weight: "bold")
  show heading.where(level: 3): set block(above: 1.6em, below: 0.8em)

  show heading.where(level: 4): set text(fill: brand-slate, size: 10.5pt, weight: "bold")
  show heading.where(level: 4): set block(above: 1.4em, below: 0.6em)

  show heading.where(level: 5): set text(fill: brand-slate, size: 10pt, weight: "bold")
  show heading.where(level: 5): set block(above: 1.2em, below: 0.5em)

  // ---------------------------------------------------------------------------
  // Tables: Modern Framed Card Matching HTML Theme
  // ---------------------------------------------------------------------------
  show figure.where(kind: "quarto-float-tbl"): it => {
    set align(left)
    show strong: s => {
      let txt = content-to-string(s)
      let parts = txt.split(":")
      if parts.len() >= 2 and parts.at(0).starts-with("Table") {
        let badge = parts.at(0).trim()
        let rest = parts.slice(1).join(":").trim()
        block(width: 100%, below: 12pt)[
          #box(
            fill: rgb("#eff6ff"),
            radius: 4pt,
            inset: (x: 6pt, y: 3.5pt),
            outset: 0pt,
            stroke: 0.5pt + rgb("#bfdbfe"),
          )[
            #text(font: font-sans, weight: "bold", size: 8.2pt, fill: brand-navy)[#badge]
          ]
          #h(8pt)
          #text(font: font-sans, weight: "bold", size: 10pt, fill: brand-slate)[#rest]
          #v(8pt)
          #line(length: 100%, stroke: 0.5pt + brand-border-light)
        ]
      } else {
        s
      }
    }

    block(
      width: 100%,
      stroke: (top: 3.5pt + brand-navy, rest: 0.75pt + brand-border),
      radius: 8pt,
      fill: white,
      inset: (x: 14pt, top: 12pt, bottom: 12pt),
      spacing: 1.8em,
      breakable: false,
      [
        #it.body
      ]
    )
  }

  set table(
    stroke: (x, y) => (bottom: 0.5pt + brand-border-light),
    fill: (col, row) => if row == 0 { rgb("#f0f7ff") } else { none },
    inset: (x: 8pt, y: 8.5pt),
  )

  show table.hline: it => line(length: 100%, stroke: 1.8pt + rgb("#2563eb"))

  show table.cell: it => {
    set text(font: font-sans)
    set par(justify: false, leading: 0.58em)
    if it.y == 0 {
      set text(weight: "bold", size: 8pt, fill: brand-navy, tracking: 0.8pt)
      it
    } else {
      set text(size: 8.5pt, fill: brand-ink)
      it
    }
  }

  // ---------------------------------------------------------------------------
  // Figures: Framed Cards with Soft Blue Badges & Muted Source Attribution
  // ---------------------------------------------------------------------------
  let format-caption(body) = {
    if not body.has("children") {
      return body
    }
    
    let children = body.children
    let source-start = none
    
    for (i, child) in children.enumerate() {
      if child.has("text") and (child.text.contains("(Source") or child.text.contains("(source")) {
        source-start = i
        break
      }
    }
    
    let main-children = if source-start != none { children.slice(0, source-start) } else { children }
    let source-children = if source-start != none { children.slice(source-start) } else { () }
    
    // Format main-children: find Figure label, style as pill badge, and drop following colon
    let clean-main = ()
    let i = 0
    while i < main-children.len() {
      let child = main-children.at(i)
      if child.has("text") and child.text.starts-with("Figure ") and clean-main.len() <= 1 {
        let fig-label = child.text
        if fig-label.ends-with(":") {
          fig-label = fig-label.slice(0, -1).trim()
        }
        clean-main.push(box(
          fill: rgb("#eff6ff"),
          radius: 4pt,
          inset: (x: 5pt, y: 2.2pt),
          stroke: 0.6pt + rgb("#bfdbfe"),
          text(font: font-sans, size: 8pt, weight: "bold", fill: rgb("#1e40af"))[#fig-label]
        ))
        clean-main.push(h(4pt))
        i += 1
        // If next is colon, skip it
        if i < main-children.len() and main-children.at(i).has("text") and main-children.at(i).text.trim() == ":" {
          i += 1
        }
        // If next is space, skip it
        if i < main-children.len() and main-children.at(i).has("text") and main-children.at(i).text == " " {
          i += 1
        }
      } else {
        clean-main.push(child)
        i += 1
      }
    }
    
    // Clean up trailing space in main content if any
    if clean-main.len() > 0 and clean-main.last() == [ ] {
      let _ = clean-main.pop()
    }
    
    let main-content = clean-main.join("")
    
    if source-children.len() == 0 {
      return main-content
    }
    
    // Clean source-children (strip leading '(' and trailing ')')
    let clean-source = ()
    for (idx, child) in source-children.enumerate() {
      if idx == 0 and child.has("text") {
        let t = child.text.trim()
        if t.starts-with("(") {
          t = t.slice(1).trim()
        }
        clean-source.push(text(t))
      } else if idx == source-children.len() - 1 and child.has("text") {
        let t = child.text.trim()
        if t.ends-with(").") {
          t = t.slice(0, -2).trim()
        } else if t.ends-with(")") {
          t = t.slice(0, -1).trim()
        }
        clean-source.push(text(t))
      } else {
        clean-source.push(child)
      }
    }
    
    let source-content = clean-source.join("")
    
    [
      #main-content
      #v(5pt)
      #line(length: 100%, stroke: (paint: brand-border, dash: "dashed", thickness: 0.5pt))
      #v(4pt)
      #block(spacing: 0pt)[
        #set text(font: font-sans, size: 7.5pt, fill: brand-muted)
        #set par(leading: 0.32em, justify: false)
        #source-content
      ]
    ]
  }

  let render-figure-card(it) = {
    // If figure has no caption or empty caption (e.g. Quarto wrapper float container), transparently unwrap body
    let has-real-caption = it.has("caption") and it.caption != none and content-to-string(it.caption.body).trim() != ""
    if not has-real-caption {
      return it.body
    }

    block(
      width: 100%,
      stroke: 0.75pt + brand-border,
      radius: 10pt,
      fill: rgb("#ffffff"),
      clip: true,
      spacing: 1.8em,
      breakable: false,
      inset: (x: 10pt, top: 10pt, bottom: 8.5pt),
      [
        #align(center)[
          #block(
            radius: 6pt,
            clip: true,
            stroke: 0.5pt + brand-border-light,
            spacing: 0pt,
            it.body
          )
        ]
        #v(7pt)
        #line(length: 100%, stroke: 0.5pt + brand-border-light)
        #v(6pt)
        #align(left)[
          #set text(font: font-serif, size: 9pt, fill: brand-ink)
          #set par(leading: 0.38em, justify: false)
          #format-caption(it.caption.body)
        ]
      ]
    )
  }

  show figure.where(kind: "quarto-float-fig"): it => render-figure-card(it)
  show figure.where(kind: image): it => render-figure-card(it)

  doc
}

// =============================================================================
// FRONT COVER PAGE (Unnumbered Page 1)
// =============================================================================
// NOTE FOR FUTURE ARTWORK:
// When your custom high-resolution cover artwork is ready (e.g. images/cover.png
// or images/cover.pdf at 8.5 x 11 inches, 300 DPI), simply uncomment the line
// below to use the full-bleed image cover and remove this programmatic block:
//
// #place(top + left, dx: -2.8cm, dy: -2.5cm, image("images/cover.png", width: 8.5in, height: 11in, fit: "cover"))
// =============================================================================

#page(
  paper: "us-letter",
  margin: (top: 3.2cm, bottom: 2.8cm, left: 2.8cm, right: 2.4cm),
  header: none,
  footer: none,
)[
  #v(0.5cm)

  // Edition Badge
  #rect(
    fill: brand-navy,
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    outset: 0pt,
  )[
    #text(
      font: font-sans,
      fill: white,
      size: 9.5pt,
      weight: "bold",
      tracking: 1.5pt,
    )[SECOND EDITION]
  ]

  #v(1.2cm)

  // Main Book Title
  #text(
    font: font-sans,
    fill: brand-ink,
    size: 28pt,
    weight: "bold",
    hyphenate: false,
  )[$title$]

  #v(0.5cm)

  // Subtitle
  #text(
    font: font-serif,
    fill: brand-navy,
    size: 14pt,
    style: "italic",
  )[$subtitle$]

  #v(0.6cm)

  // Oxford Navy Divider Rule
  #line(length: 100%, stroke: 2pt + brand-navy)

  #v(1.2cm)

  // Authors List
  #text(
    font: font-sans,
    fill: rgb("#334155"),
    size: 10pt,
    weight: "medium",
  )[
    #text(weight: "bold", fill: brand-ink)[Authors:]\
    #v(4pt)
    Dr. Dino Bozonelos #h(8pt)·#h(8pt)
    Dr. Julia Wendt #h(8pt)·#h(8pt)
    Dr. Charlotte Lee\
    Jessica Scarffe #h(8pt)·#h(8pt)
    Brian Barrick #h(8pt)·#h(8pt)
    Dr. Masahiro Omae\
    Dr. Josh Franco #h(8pt)·#h(8pt)
    Dr. Byran Martin #h(8pt)·#h(8pt)
    Stefan Veldhuis
  ]

  #v(1fr)

  // Publisher & License Footer
  #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
  #v(0.4cm)
  #grid(
    columns: (1fr, auto),
    gutter: 1cm,
    [
      #text(font: font-sans, size: 8.5pt, fill: brand-muted)[
        *Academic Senate for California Community Colleges (ASCCC)*\
        Open Educational Resources Initiative (OERI)\
        Shared under a *CC BY-NC 4.0* International License
      ]
    ],
    [
      #align(right + bottom)[
        #text(font: font-sans, size: 9pt, weight: "bold", fill: brand-navy)[
          OpenAudio OER
        ]
      ]
    ]
  )
]

#pagebreak()

// =============================================================================
// COPYRIGHT & CATALOGING PAGE (Page 2)
// =============================================================================
#page(
  paper: "us-letter",
  margin: (top: 3.5cm, bottom: 2.5cm, left: 2.8cm, right: 2.4cm),
  header: none,
  footer: none,
)[
  #v(1fr)
  #text(font: font-sans, size: 12pt, weight: "bold", fill: brand-ink)[$title$]\
  #text(font: font-serif, size: 10pt, style: "italic", fill: brand-navy)[$subtitle$]\
  #v(0.4cm)
  #line(length: 4cm, stroke: 1pt + brand-navy)
  #v(0.4cm)
  #text(font: font-sans, size: 8.5pt, fill: brand-slate)[
    *Authors:* Dr. Dino Bozonelos, Dr. Julia Wendt, Dr. Charlotte Lee, Jessica Scarffe, Brian Barrick, Dr. Masahiro Omae, Dr. Josh Franco, Dr. Byran Martin, and Stefan Veldhuis\
    \
    *Publisher:* Academic Senate for California Community Colleges (ASCCC) Open Educational Resources Initiative (OERI)\
    \
    *License:* Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)\
    You are free to share (copy and redistribute the material in any medium or format) and adapt (remix, transform, and build upon the material) under the following terms: Attribution and NonCommercial.\
    \
    *OpenAudio OER Edition:* Featuring integrated audio chapters, synchronized episode timestamps, and interactive study resources.\
    \
    *Publication Date:* 2026 · Second Edition
  ]
]

#pagebreak()

// =============================================================================
// TABLE OF CONTENTS (Page 3)
// =============================================================================
#page(
  paper: "us-letter",
  margin: (top: 2.2cm, bottom: 2.2cm, left: 2.8cm, right: 2.4cm),
  header: none,
  footer: context [
    #set align(center)
    #set text(font: font-sans, size: 8.5pt, fill: black)
    #counter(page).display("i")
  ]
)[
  #v(0.4cm)
  #text(font: font-sans, size: 18pt, weight: "bold", fill: black)[Table of Contents]
  #v(0.3cm)
  #line(length: 100%, stroke: 1.5pt + black)
  #v(0.4cm)

  #show outline.entry.where(level: 1): it => {
    v(0.65em)
    text(font: font-sans, weight: "bold", size: 10pt, fill: black)[
      #it
    ]
  }

  #show outline.entry.where(level: 2): it => {
    v(0.12em)
    text(font: font-serif, weight: "regular", size: 9pt, fill: black)[
      #it
    ]
  }

  #outline(
    title: none,
    depth: 2,
    indent: 1.4em,
  )
]

#pagebreak()

// Reset page numbering for main body (Chapter 1 begins on Arabic Page 1)
#counter(page).update(1)

#show: doc => book-theme(
  title: [$title$],
  subtitle: [$subtitle$],
  authors: (
$for(author)$
$if(author.name)$
    ( name: [$author.name$], affiliation: [$author.affiliation$] ),
$else$
    ( name: [$author$], affiliation: "" ),
$endif$
$endfor$
  ),
  date: [$date$],
  doc,
)

$body$
