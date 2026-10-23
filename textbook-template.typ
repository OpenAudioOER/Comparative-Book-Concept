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
// Callout Boxes: Modern Left-Accent Card (Icon removed, elegant tracked header)
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
    fill: rgb("#f8fbff"),
    stroke: (left: 3.5pt + icon_color, rest: 0.5pt + brand-border),
    width: 100%,
    radius: (right: 5pt, left: 0pt),
    inset: (x: 14pt, y: 11pt),
    spacing: 1.4em,
    [
      #block(below: 8pt)[
        #text(font: font-sans, weight: "bold", fill: icon_color, size: 9pt, tracking: 1.2pt)[
          #upper(title)
        ]
      ]
      #text(font: font-serif, size: 9.6pt, fill: brand-ink)[
        #body
      ]
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
  show heading: it => {
    set text(font: font-sans, hyphenate: false)
    if it.level == 1 {
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
    } else if it.level == 2 {
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
    } else if it.level == 3 {
      // Level 3: Subsection (Inline flow)
      v(1.3em)
      text(fill: brand-slate, size: 11.5pt, weight: "bold")[
        #it.body
      ]
      v(0.5em)
    } else if it.level == 4 {
      // Level 4: Sub-subsection
      v(1.1em)
      text(fill: brand-slate, size: 10.5pt, weight: "bold")[
        #it.body
      ]
      v(0.4em)
    } else {
      v(0.9em)
      text(fill: brand-slate, size: 10pt, weight: "bold")[
        #it.body
      ]
      v(0.4em)
    }
  }

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
  // Figures: Framed with Fine-Print Captions (body-only caption, 7.6pt)
  // ---------------------------------------------------------------------------
  show figure.caption: it => {
    set align(center)
    set par(leading: 0.55em)
    text(font: font-sans, size: 7.6pt, fill: brand-slate)[#it.body]
  }

  show figure.where(kind: image): it => {
    set align(center)
    block(
      width: 100%,
      spacing: 1.5em,
      [
        #block(
          stroke: 0.75pt + brand-border,
          radius: 4pt,
          clip: true,
          inset: 0pt,
          it.body
        )
        #if it.has("caption") [
          #v(5pt)
          #it.caption
        ]
      ]
    )
  }

  // ---------------------------------------------------------------------------
  // Table of Contents Styling
  // ---------------------------------------------------------------------------
  show outline.entry.where(level: 1): it => {
    v(0.6em)
    text(font: font-sans, weight: "bold", size: 10.5pt, fill: brand-navy)[
      #it
    ]
  }

  show outline.entry.where(level: 2): it => {
    text(font: font-serif, size: 9.5pt, fill: brand-ink)[
      #it
    ]
  }

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
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.8cm, right: 2.4cm),
  header: none,
  footer: context [
    #set align(center)
    #set text(font: font-sans, size: 8.5pt, fill: brand-muted)
    #counter(page).display("i")
  ]
)[
  #v(0.8cm)
  #text(font: font-sans, size: 18pt, weight: "bold", fill: brand-navy)[Table of Contents]
  #v(0.4cm)
  #line(length: 100%, stroke: 1.5pt + brand-navy)
  #v(0.6cm)
  #outline(
    title: none,
    depth: 2,
    indent: 1.2em,
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
