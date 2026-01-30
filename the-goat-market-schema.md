# The GOAT Market 2026: Project Schema & Documentation

**Project Name:** the-goat-market-2026  
**Type:** R/Shiny Quarto Project  
**Purpose:** Economics course materials, teaching tools, and market simulation data for NMSU ECON 304 and related courses  
**Last Updated:** January 30, 2026  
**Root Location:** `~/the-goat-market-2026`

---

## 1. Project Root Structure

```
the-goat-market-2026/
├── _quarto.yml                    # Quarto configuration file
├── .gitignore                     # Git ignore rules
├── .Rhistory                      # R command history
├── .Rprofile                      # R profile settings
├── index.qmd                      # Main landing page (Quarto)
├── README.md                      # Project readme
├── LICENSE                        # Project license
├── munge_packages.R               # Data munging/preprocessing script
├── courses/                       # Course materials directory
├── docs/                          # Generated documentation (output)
├── resources/                     # Shared resources and assets
├── shiny-apps/                    # Shiny applications
├── renv/                          # R environment management
├── renv.lock                      # Locked R package versions
├── _quarto.yml                    # (Quarto configuration)
├── the-goat-market-2026.Rproj    # RStudio project file (205 B)
└── [potentially other files]
```

---

## 2. Courses Subdirectory Structure

### Location: `the-goat-market-2026/courses/`

```
courses/
└── econ304/                       # ECON 304 - [Course Title]
    ├── index.html                 # Course home page (rendered, 29.3 KB)
    ├── index.qmd                  # Course index (Quarto source, 2.6 KB)
    ├── information/               # Course information
    ├── learning-journal/          # Student learning journal materials
    ├── lectures/                  # Lecture notes and slides
    ├── resources/                 # Course-specific resources
    ├── syllabus_pdf_files/        # Syllabus PDFs
    └── worksheets/                # Problem sets and worksheets
```

---

## 3. Detailed Directory Descriptions

### 3.1 Root Configuration & Metadata Files

| File | Type | Size | Purpose |
|------|------|------|---------|
| `_quarto.yml` | YAML Config | 3.8 KB | Central Quarto configuration for site rendering |
| `.Rprofile` | R Config | 26 B | R session initialization and environment setup |
| `.Rhistory` | History | 185 B | R console command history (auto-generated) |
| `.gitignore` | Config | 75 B | Git repository exclusion rules |
| `LICENSE` | Text | 1 KB | Project license terms |
| `README.md` | Markdown | 1.8 KB | Project overview and quick start guide |
| `the-goat-market-2026.Rproj` | Project | 205 B | RStudio project file |

### 3.2 Root R Scripts

| File | Type | Size | Purpose |
|------|------|------|---------|
| `munge_packages.R` | R Script | 1.8 KB | Data munging, cleaning, and package dependency management |
| `index.qmd` | Quarto | 1 KB | Root-level landing page source |

### 3.3 R Environment Management

| File | Type | Size | Purpose |
|------|------|------|---------|
| `renv/` | Directory | — | Isolated R environment (project-specific packages) |
| `renv.lock` | Lock File | 2.3 KB | Reproducible package version snapshot |

### 3.4 Course Materials: ECON 304

**Path:** `courses/econ304/`

| Item | Type | Size | Purpose |
|------|------|------|---------|
| `index.qmd` | Quarto | 2.6 KB | Course home page source code |
| `index.html` | HTML | 29.3 KB | Rendered course home page |
| `information/` | Folder | — | Course meta-information (logistics, schedules, grading) |
| `learning-journal/` | Folder | — | Student reflection and learning activities |
| `lectures/` | Folder | — | Lecture slides, notes, and teaching materials |
| `resources/` | Folder | — | Supplementary materials (data, readings, tools) |
| `syllabus_pdf_files/` | Folder | — | Course syllabus and PDF documents |
| `worksheets/` | Folder | — | Problem sets, assignments, and practice materials |

---

## 4. Shiny Applications

**Path:** `the-goat-market-2026/shiny-apps/`

This directory contains interactive Shiny applications for market simulation, data exploration, or teaching demonstrations. Each Shiny app typically includes:
- `app.R` or `ui.R` + `server.R`
- Supporting data and helper functions

---

## 5. Resources Directory

**Path:** `the-goat-market-2026/resources/`

Shared assets used across courses and materials:
- Data files
- Images and graphics
- Helper functions
- Reference materials
- Datasets for exercises

---

## 6. Documentation Directory

**Path:** `the-goat-market-2026/docs/`

Auto-generated output from Quarto rendering:
- Compiled HTML pages
- Rendered course materials
- Website static files (for GitHub Pages deployment)

---

## 7. File Type Reference Guide

| Extension | Type | Description |
|-----------|------|-------------|
| `.qmd` | Quarto Markdown | Source files for rendering (can mix R, text, YAML) |
| `.html` | HTML | Rendered web pages |
| `.Rproj` | RStudio Project | Project metadata and settings |
| `.R` | R Script | Executable R code |
| `.yml` / `.yaml` | YAML Config | Configuration files (Quarto, Renv) |
| `.lock` | Lock File | Reproducible dependency snapshots |
| `.md` | Markdown | Static documentation |
| `.pdf` | PDF | Portable document format |
| `.csv` | CSV Data | Comma-separated values data |

---

## 8. Project Workflow & Best Practices

### Development Cycle
1. **Edit source files** (`.qmd`, `.R` scripts, `.md`)
2. **Run `munge_packages.R`** to ensure dependencies are installed
3. **Render with Quarto** (`quarto render` or RStudio Render button)
4. **Preview HTML** output locally
5. **Commit to Git** and push to GitHub
6. **Deploy to GitHub Pages** (automatic or manual)

### Package Management
- Use `renv` for reproducible environments
- Update `renv.lock` after installing new packages
- Team members run `renv::restore()` to match locked versions

### Directory Naming Conventions
- Use **lowercase with hyphens** for directories: `learning-journal`, `syllabus-pdf-files`
- Use **underscores** for R scripts: `munge_packages.R`
- Use **SCREAMING_SNAKE_CASE** for data variables in code

---

## 9. File Organization Summary Table

| Category | Path | Contains |
|----------|------|----------|
| **Configuration** | Root | Quarto, R, Git, Renv configs |
| **Source Code** | Root + subdirs | `.qmd`, `.R` files |
| **Course Materials** | `courses/econ304/` | Lectures, worksheets, syllabus |
| **Interactive Tools** | `shiny-apps/` | Shiny applications |
| **Shared Assets** | `resources/` | Data, images, utilities |
| **Output** | `docs/` | Generated HTML and static files |
| **Environment** | `renv/`, `renv.lock` | R package dependencies |

---

## 10. Security & Data Protection Considerations

This project may contain:
- **Student data** (names, grades, submissions) → Use `.gitignore` to exclude
- **Sensitive teaching materials** → Consider access controls
- **Personally identifiable information (PII)** → Never commit raw student records

### Security Checklist
- [ ] `.gitignore` excludes student data files
- [ ] `.Rprofile` does not contain passwords or API keys
- [ ] `.gitignore` excludes `renv/` if it contains system-specific binaries
- [ ] Shiny apps validate and sanitize user inputs
- [ ] No hardcoded credentials in `.R` or `.qmd` files
- [ ] Use environment variables for secrets (via `.Renviron`, not tracked by Git)

---

## 11. Quick Reference: Key Locations

| Purpose | Location |
|---------|----------|
| Add a new lecture | `courses/econ304/lectures/` |
| Add a problem set | `courses/econ304/worksheets/` |
| Configure site | Root `_quarto.yml` |
| Manage dependencies | `renv.lock` (via R: `renv::snapshot()`) |
| Update course info | `courses/econ304/information/` |
| Render all materials | `quarto render` in terminal |
| Launch Shiny app | Run app file from `shiny-apps/` |

---

## 12. Dependencies & Tools

**Primary Tools:**
- **R** (4.x recommended)
- **Quarto** (latest stable)
- **RStudio** (optional but recommended)
- **Git** (version control)

**Key R Packages** (managed by renv):
- `shiny` – Interactive web apps
- `ggplot2` – Visualization
- `dplyr` – Data manipulation
- `quarto` – R integration with Quarto

---

## Notes for AI Assistant

When working on this project:
1. **Respect the schema** – File organization follows deliberate structure
2. **Check renv.lock** before suggesting new packages
3. **Test Quarto rendering** after code changes
4. **Validate security** – Don't hardcode credentials or expose student data
5. **Use Linux conventions** – Project runs on Ubuntu; test on Linux paths
6. **Preserve backward compatibility** – Changes to structure affect course URLs

---

*This schema was generated January 30, 2026 and reflects the current state of the-goat-market-2026 project.*
