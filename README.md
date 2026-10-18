# Vania Janet Raya Ríos — academic website

A static academic homepage for PhD applications, hosted on GitHub Pages: https://vania-janet.github.io/

No framework, no build step, no JavaScript, no trackers, and no third-party requests (the fonts are self-hosted).

## Files

| Path | What it is |
| --- | --- |
| `index.html` | All page content: research threads, publications, experience, education, honours, teaching, projects, skills, contact |
| `styles.css` | Design tokens and layout. Colours and fonts are defined at the top of the file |
| `assets/img/semeval-architecture.png` | Figure 1 of the SemEval 2026 paper, cropped from `img/diagram_full_RAG_flow.png` in the team repository |
| `assets/fonts/` | Newsreader and Hanken Grotesk, subset to Latin and served as WOFF (SIL Open Font License) |
| `assets/Vania_Raya_CV.pdf` | Downloadable CV (retained from existing site) |
| `assets/Samsung_Essay_*.pdf` | Original Spanish essay and unofficial English translation (retained from existing site) |

## Editing

- **Text and links:** edit `index.html` directly. Each section is one `<section class="section">` with a title in the left margin.
- **Portrait:** the page currently loads your GitHub avatar. For a professional headshot, add `assets/profile.jpg` (square, at least 512 px) and change the `src` of `.hero__photo` in `index.html`.
- **Update the CV:** replace `assets/Vania_Raya_CV.pdf` and keep the file name.
- **Accent colour:** change `--accent` and `--accent-ink` in `styles.css`.
- **Anonymous submissions:** Do not publish manuscript titles, submission links or details that identify anonymous submissions during peer review.

## Figures

The pipeline and result figures in the Research section are inline SVG drawn from the numbers reported in the papers and CV. The pipeline diagram for the phenotype manuscript is a schematic, and is labelled as such on the page. Replace it with a figure from the manuscript once it is public.

## Publishing

In the repository, open **Settings → Pages**, choose *Deploy from a branch*, select **main** and **/(root)**. The `.nojekyll` file makes GitHub serve the files as they are.
