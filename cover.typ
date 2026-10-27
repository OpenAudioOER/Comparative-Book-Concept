#let cover-img = "images/CoverFinal.png"

#set page(
  paper: "us-letter",
  margin: (top: 2.4cm, bottom: 2.0cm, left: 2.4cm, right: 2.4cm),
  header: none,
  footer: none,
  // Native full-bleed background artwork
  background: image(cover-img, width: 100%, height: 100%, fit: "cover"),
)

#set text(font: "Plus Jakarta Sans", fill: rgb("#ffffff"))

// -----------------------------------------------------------------------------
// Top Header Block
// -----------------------------------------------------------------------------
#stack(
  spacing: 0pt,
  
  rect(
    fill: rgb("#ffffff").transparentize(88%),
    stroke: 0.75pt + rgb("#93c5fd").transparentize(40%),
    radius: 4pt,
    inset: (x: 10pt, y: 5.5pt),
  )[
    #text(
      fill: rgb("#e0f2fe"),
      size: 8pt,
      weight: "bold",
      tracking: 2.2pt,
    )[SECOND EDITION]
  ],
  
  v(22pt),
  
  par(leading: 0.80em)[
    #text(
      size: 36pt,
      weight: "extrabold",
      tracking: -0.5pt,
    )[Introduction to\ Comparative Government\ and Politics]
  ],
  
  v(22pt),
  
  text(
    font: "Source Serif 4",
    fill: rgb("#cbd5e1"),
    size: 14pt,
    style: "italic",
  )[An Open Educational Resource Textbook],
  
  v(20pt),
  
  line(
    length: 3.2cm,
    stroke: (paint: rgb("#60a5fa"), thickness: 2pt, cap: "round"),
  ),
)

#v(1fr)

// -----------------------------------------------------------------------------
// Footer Block
// -----------------------------------------------------------------------------
#grid(
  columns: (1fr, auto),
  gutter: 1cm,
  align: bottom,
  [
    #stack(
      spacing: 0pt,
      text(size: 7.5pt, weight: "bold", fill: rgb("#93c5fd"), tracking: 1.8pt)[LEAD AUTHOR],
      v(5pt),
      text(size: 9.5pt, weight: "semibold", fill: rgb("#ffffff"))[Dino Bozonelos],
      
      v(16pt),
      
      text(size: 7.5pt, weight: "bold", fill: rgb("#93c5fd"), tracking: 1.8pt)[CONTRIBUTING AUTHORS],
      v(5pt),
      par(leading: 0.75em)[
        #text(size: 9.5pt, weight: "semibold", fill: rgb("#e2e8f0"))[
          Austin Barraza · Brian Barrick · Josh Franco\
          Charlotte Lee · Byran Martin · Masahiro Omae\
          Jessica Scarffe · Stefan Veldhuis · Julia Wendt
        ]
      ]
    )
  ],
  [
    #align(right + bottom)[
      #stack(
        spacing: 4pt,
        align(right)[
          #text(size: 9pt, weight: "bold", tracking: 0.5pt, fill: rgb("#ffffff"))[ASCCC OERI]
        ],
        align(right)[
          #text(size: 7.5pt, weight: "medium", fill: rgb("#94a3b8"))[CC BY-NC 4.0]
        ],
      )
    ]
  ]
)
