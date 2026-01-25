Website for economics teaching at NMSU
# The GOAT Market: Economics Teaching Hub

Teaching materials and interactive tools for economics courses at NMSU.

## Courses

- **ECON 304**: Money & Banking
- **ECON 2110**: Principles of Macroeconomics
- **ECON 2120**: Principles of Microeconomics (2 sections)

## About This Site

This repository contains:
- **Static course materials** (syllabi, schedules, resources) hosted on GitHub Pages
- **Interactive practice tools** (polls, graphing exercises, simulators) hosted on ShinyApps.io
- **Assignment submissions and grades** managed through Canvas LMS

## Website

Visit the course site: [The GOAT Market](https://meghandownes.github.io/the-goat-market-2026)

## Technology Stack

- **Quarto** - Static site generation and documentation
- **R/Shiny** - Interactive web applications
- **GitHub Pages** - Free static site hosting
- **ShinyApps.io** - Free Shiny application hosting
- **Bootstrap/Lux** - CSS theme

## File Structure
docs/ # Quarto website (GitHub Pages)
├── _quarto.yml
├── index.qmd
├── courses/
│ ├── ECON304/
│ ├── ECON2110/
│ └── ECON2120/
└── resources/

shinyapps/ # Standalone Shiny apps (ShinyApps.io)
├── econ304-fed-rates/
├── econ2110-macro-viz/
└── econ2120-supply-demand/

R/ # Shared R utilities
└── *.R files

## Security & Privacy

- **No student data** stored in this repository
- **Canvas LMS** manages all grades and assignment submissions
- **Anonymous polls/surveys only** on ShinyApps
- All code reviewed for security vulnerabilities

- License
This project is licensed under the MIT License - see the LICENSE file for details.

Contact
For questions or issues, please open a GitHub issue or contact me at cmdownes@nmsu.edu

Last updated: January 2026
