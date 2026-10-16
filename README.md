# Comparative Politics (2nd Edition) — Digital Textbook Proof of Concept

An open-access, modern digital textbook proof of concept built with **[Quarto](https://quarto.org)** and hosted on **Vercel**.

## 📖 Features

* **Editorial Typography & Visual Polish**: Custom SCSS theme pairing *Newsreader* (editorial book serif) with *Plus Jakarta Sans* (clean geometric headers) and warm book parchment background.
* **Modern Book Homepage**: Interactive hero banner with 3D perspective hardcover artwork, stats bar, and chapter curriculum directory.
* **Reading Progress Bar**: Native CSS scroll-driven progress indicator across the top of every chapter.
* **Interactive Pedagogical Widgets**: Expandable inline Concept Checks and self-assessment checks.
* **WCAG 2.1 AA / WAVE Compliant**: High contrast ratios (7:1+), semantic heading hierarchy, full figure alternative text, and accessible ARIA attributes.
* **OER & LibreTexts Ready**: Structured for single-source export to HTML, PDF, EPUB, and LibreTexts OER libraries.

## 🚀 Local Development

To compile and preview locally with Quarto:

```bash
# Render to HTML
quarto render --to html

# Preview locally
quarto preview
```

## 🌐 Deployment

This project deploys automatically to **Vercel** via `_book/` static output directory configured in `vercel.json`.

## 📜 License

Content licensed under **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)**.
