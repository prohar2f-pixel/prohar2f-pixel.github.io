# Vizual Case Carousels Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the long case gallery with two fast, accessible carousels for real desktop and mobile screenshots.

**Architecture:** Keep the static case page and its existing tokens. Add one page-scoped JavaScript module that initializes each `[data-carousel]` independently; HTML retains visible first slides without JavaScript. Desktop and mobile carousels share behavior but use different CSS compositions.

**Tech Stack:** Static HTML, CSS, vanilla JavaScript, PowerShell contract checks, real WebP screenshots.

## Global Constraints

- No autoplay or external carousel dependency.
- Use only verified screenshots from `nedvizhimostdoneck.ru`.
- Preserve the existing page, links, metadata and CTA.
- Desktop controls use `#0F5D46` and `#E1AF3F`; portfolio focus remains purple.
- Support 390, 768, 1024 and 1440 px, keyboard, swipe and reduced motion.
- Without JavaScript, the first slide and description of each carousel remain readable.

---

### Task 1: Carousel contract and real assets

**Files:**
- Modify: `tools/check-vizual-case.ps1`
- Create: `assets/cases/vizual/vizual-contacts.webp`
- Create: `assets/cases/vizual/vizual-mobile-catalog.webp`
- Create: `assets/cases/vizual/vizual-mobile-object.webp`
- Create: `assets/cases/vizual/vizual-mobile-team.webp`

**Interfaces:**
- Produces five desktop asset paths and four mobile asset paths consumed by the case HTML.

- [ ] Add failing assertions for two `[data-carousel]` roots, slide counts 5/4, carousel script and all new files.
- [ ] Run `powershell -ExecutionPolicy Bypass -File tools\check-vizual-case.ps1` and verify failure.
- [ ] Capture the contacts page at desktop width and catalog/object/team at 390 px from the live project.
- [ ] Optimize the captures to WebP while preserving readable interface text.
- [ ] Run the contract and verify the asset assertions pass while markup assertions still fail.
- [ ] Commit assets and checks with `test: define vizual carousel contract` and `assets: add vizual carousel screens`.

### Task 2: Semantic carousel markup

**Files:**
- Modify: `cases/vizual-real-estate/index.html`

**Interfaces:**
- Produces `.cv-carousel[data-carousel="desktop|mobile"]`, `.cv-carousel-slide`, `[data-carousel-prev]`, `[data-carousel-next]`, `[data-carousel-dot]` and `[data-carousel-status]`.

- [ ] Replace `.cv-gallery` with a desktop region containing five slides and a mobile region containing four slides.
- [ ] Keep only the first slide unhidden in source HTML; mark each region with an accessible label.
- [ ] Add concise factual titles and one-sentence descriptions for every screen.
- [ ] Add explicit image dimensions, lazy loading, async decoding and meaningful alt text.
- [ ] Add `<script src="/assets/case-vizual-carousel.js" defer></script>` before `</body>`.
- [ ] Run the contract and local-link checks.
- [ ] Commit with `feat: add dual vizual screenshot carousels`.

### Task 3: Project-specific visual system

**Files:**
- Modify: `assets/case-vizual.css`

**Interfaces:**
- Consumes the Task 2 class names without changing behavior.

- [ ] Add a desktop 75/25 presentation grid with 16:10 media, right information rail and a restrained next-slide edge cue.
- [ ] Add a distinct centered phone stage for the mobile carousel, with description and controls below.
- [ ] Use green/gold only inside carousel controls and progress; retain purple focus outlines.
- [ ] Add stable slide heights and responsive layouts for 980 and 700 px breakpoints.
- [ ] Add one 300 ms horizontal transition and disable it under `prefers-reduced-motion`.
- [ ] Verify no horizontal overflow at all four target widths.
- [ ] Commit with `style: refine vizual carousel presentation`.

### Task 4: Independent accessible behavior

**Files:**
- Create: `assets/case-vizual-carousel.js`

**Interfaces:**
- `initCarousel(root: HTMLElement): void` initializes one root.
- `show(index: number, announce = true): void` wraps the index, toggles slides/dots and updates status.

- [ ] Implement independent state per root and wrapped previous/next navigation.
- [ ] Toggle `hidden`, `aria-hidden`, `.is-active` and `aria-current` consistently.
- [ ] Add Left/Right keyboard handling only while the carousel region is focused.
- [ ] Add horizontal pointer swipe with a 48 px threshold and ignore primarily vertical gestures.
- [ ] Update an `aria-live="polite"` status with the active title and count.
- [ ] Leave source HTML usable when the script does not execute.
- [ ] Run contract and link checks.
- [ ] Commit with `feat: add accessible vizual carousel controls`.

### Task 5: Visual QA and publication

**Files:**
- Modify only if a verified defect is found.

**Interfaces:**
- Validates the complete page, not a new public API.

- [ ] Run `check-vizual-case.ps1`, `check-local-links.ps1` and `git diff --check`.
- [ ] Test both carousels at 390, 768, 1024 and 1440 px.
- [ ] Verify arrows, dots, keyboard, swipe, independent state, stable height and console logs.
- [ ] Verify every slide image loads and each image has non-empty alt text.
- [ ] Inspect screenshots of both carousel states on mobile and desktop.
- [ ] Push `main`, wait for GitHub Pages and verify live HTML, CSS, JavaScript and new assets return HTTP 200.
