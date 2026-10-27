#set page(
  width: 10in,
  height: 10in,
  fill: none,
  margin: (top: 0.6in, bottom: 0.8in, left: 0.75in, right: 0.75in),
  header: none,
  footer: none,
)

#set text(font: "Plus Jakarta Sans", fill: rgb("#ffffff"))

#align(top + left)[
  #stack(
    spacing: 0pt,

    // Second Edition Badge
    rect(
      fill: rgb("#ffffff").transparentize(88%),
      stroke: 0.75pt + rgb("#93c5fd").transparentize(40%),
      radius: 4pt,
      inset: (x: 10pt, y: 5.5pt),
    )[
      #text(
        fill: rgb("#e0f2fe"),
        size: 8.5pt,
        weight: "bold",
        tracking: 2.2pt,
      )[SECOND EDITION]
    ],

    v(16pt),

    par(leading: 0.78em)[
      #text(
        size: 39pt,
        weight: "extrabold",
        tracking: -0.5pt,
      )[Introduction to\ Comparative Government\ and Politics]
    ],

    v(16pt),

    text(
      font: "Source Serif 4",
      fill: rgb("#cbd5e1"),
      size: 17pt,
      style: "italic",
    )[An OER Audiobook],

    v(15pt),

    line(
      length: 2.3in,
      stroke: (paint: rgb("#60a5fa"), thickness: 2pt, cap: "round"),
    ),
  )
]

#v(1fr)

#align(bottom + left)[
  #stack(
    spacing: 5.5pt,
    text(
      size: 13.5pt,
      weight: "bold",
      fill: rgb("#ffffff"),
      tracking: 2pt,
    )[DINO BOZONELOS],
    text(
      size: 13.5pt,
      weight: "bold",
      fill: rgb("#ffffff"),
      tracking: 2pt,
    )[& CONTRIBUTING AUTHORS],
    text(
      size: 13.5pt,
      weight: "bold",
      fill: rgb("#93c5fd"),
      tracking: 2.2pt,
    )[OPENAUDIO OER],
  )
]
