# CV Template

This repository contains a reusable CV and cover letter template built with Markdown, Pandoc, and LaTeX. The
default files provide sample content that you can replace with your own experience, projects, and education.

Examples:

- [CV PDF](https://jorgesintes.dev/files/examples/cv.pdf)
- [Cover Letter PDF](https://jorgesintes.dev/files/examples/cover-letter.pdf)

# Requirements

- `pandoc`
- a LaTeX engine compatible with `xelatex`

# Build the default files

```bash
make cv
make letter
make both
```

Generated files are written to `pdf/` and are treated as build artifacts.

# Build with Docker

```bash
docker build -t cv-build .
make docker-cv
make docker-letter
make docker-both
```

These targets run the container as your host user so the generated files keep the right ownership.

# Create a job-specific application folder

```bash
make new APP=my-application
```

This copies the default CV and cover letter into `applications/my-application/` so you can tailor them for a
specific role.

# Build a job-specific application

```bash
cd applications/my-application
make cv
make letter
make both
make docker-cv
make docker-letter
make docker-both
```

The application Makefile builds the job-specific `cv.md` and `letter.md` while reusing the shared templates
from the repository root.

# Optional publish targets

The provided `publish` and `publish_letter` targets are examples. Before using them, update `PUBLISH_TARGET`
in `Makefile` or `application.Makefile` to match your own hosting setup.

# Customize the template

Replace these first:

- contact details in `cv.md` and `letter.md`
- experience, projects, and education entries in `cv.md`
- the default cover letter text in `letter.md`
- optional publish settings in `Makefile` and `application.Makefile`
- generated `pdf/` outputs if you want to stop tracking them in git

You can also:

- remove social links you do not want to show
- add or remove sections to fit your profile
- replace sample links with portfolio, GitHub, or publication URLs
- adjust colors, spacing, and typography in `template_shared.tex`

# Notes

- The template uses `template_cv.tex` for the CV and `template_letter.tex` for the cover letter.
- Shared styles live in `template_shared.tex`.
- Application-specific folders reuse the templates from the repository root.
- For app builds, run commands from inside `applications/<slug>/` so the relative template paths still
  resolve.
