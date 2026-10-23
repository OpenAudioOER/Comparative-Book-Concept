// =============================================================================
// FRONT COVER PAGE (Option 2: Programmatic Vector Cover)
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
  margin: (top: 3.2cm, bottom: 2.8cm, inside: 2.8cm, outside: 2.4cm),
  header: none,
  footer: none,
)[
  #v(0.5cm)

  // Edition Badge
  #rect(
    fill: rgb("1e3a8a"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    outset: 0pt,
  )[
    #text(
      font: "Plus Jakarta Sans",
      fill: white,
      size: 9.5pt,
      weight: "bold",
      tracking: 1.5pt,
    )[SECOND EDITION]
  ]

  #v(1.2cm)

  // Main Book Title
  #text(
    font: "Plus Jakarta Sans",
    fill: rgb("0f172a"),
    size: 28pt,
    weight: "bold",
    hyphenate: false,
  )[Introduction to Comparative Government and Politics]

  #v(0.5cm)

  // Subtitle
  #text(
    font: "Source Serif 4",
    fill: rgb("1e3a8a"),
    size: 14pt,
    style: "italic",
  )[An Open Educational Resource Textbook]

  #v(0.6cm)

  // Oxford Navy Divider Rule
  #line(length: 100%, stroke: 2pt + rgb("1e3a8a"))

  #v(1.2cm)

  // Authors List
  #text(
    font: "Plus Jakarta Sans",
    fill: rgb("334155"),
    size: 10pt,
    weight: "medium",
  )[
    #text(weight: "bold", fill: rgb("0f172a"))[Authors:]\
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
  #line(length: 100%, stroke: 0.5pt + rgb("cbd5e1"))
  #v(0.4cm)
  #grid(
    columns: (1fr, auto),
    gutter: 1cm,
    [
      #text(font: "Plus Jakarta Sans", size: 8.5pt, fill: rgb("64748b"))[
        *Academic Senate for California Community Colleges (ASCCC)*\
        Open Educational Resources Initiative (OERI)\
        Shared under a *CC BY-NC 4.0* International License
      ]
    ],
    [
      #align(right + bottom)[
        #text(font: "Plus Jakarta Sans", size: 9pt, weight: "bold", fill: rgb("1e3a8a"))[
          OpenAudio OER
        ]
      ]
    ]
  )
]

#pagebreak()
