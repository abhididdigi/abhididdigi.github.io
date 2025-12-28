# Design Critique & Improvement Plan
**Perspective:** FAANG Design Systems / Product Design
**Goal:** Elevate the blog from "functional developer template" to "polished, professional engineering journal."

## Executive Summary
The current design is clean, functional, and minimal—which is a great foundation. It uses high-quality typefaces (Inter, JetBrains Mono) and supports dark mode. However, it suffers from "default template syndrome." The visual hierarchy is flat, the navigation feels slightly unrefined, and the spacing (vertical rhythm) lacks intention. It needs to feel more "crafted."

## Detailed Critique

### 1. Typography & Hierarchy
*   **Strengths:** choice of `Inter` for UI/body and `JetBrains Mono` for code/meta is excellent. It signals "modern tech" immediately.
*   **Weaknesses:**
    *   **Flatness:** On the homepage, the post date and post title have similar visual weight. The eye isn't guided.
    *   **Contrast:** The grey used for dates (`#86868b`) is borderline low-contrast, especially in dark mode.
    *   **Headings:** In posts, the `h1` and `h2` sizes are functional but lack a "typesetting" feel. The margins around them (margin-top vs margin-bottom) could be more deliberate to group content better.

### 2. Layout & Spacing (Vertical Rhythm)
*   **Homepage List:** The post list is too dense. `margin-bottom: 0.1em` makes it look like a raw data dump rather than a curated list of articles. It needs breathing room.
*   **Container Width:** `max-width: 750px` is good for reading, but the padding on mobile (`padding: 0 1em`) feels a bit tight to the edges.
*   **Footer:** The footer feels disconnected. The links are floating without a strong grid alignment.

### 3. Navigation
*   **Inconsistency:** The desktop nav uses text ("home", "about"), while mobile tries to use icons/symbols ("/", SVG icon). This cognitive load switch isn't necessary for such a simple site.
*   **Theme Toggle:** The emoji toggle (☀️/🌙) works but feels "toy-like." A polished SVG icon transition is standard expectation for a high-quality engineering blog.

### 4. Visual Identity
*   **"Generic" Feel:** It looks very similar to the default Jekyll `minima` theme. It lacks a signature interaction or visual flair that says "Abhiram Diddigi."
*   **Links:** The standard blue is fine, but we could play with a slightly more unique accent color or a underline style (e.g., `text-decoration-thickness`) to modernize it.

---

## Actionable Improvement Plan

### Phase 1: The "Polish" (Low Effort, High Impact)
*   [ ] **Breathing Room:** Increase spacing between homepage post items. Change `margin-bottom` from `0.1em` to `1.5em` or `2em`.
*   [ ] **Visual Grouping:** On the homepage, make the Date a block element above the Title on mobile, or ensure the date column has a fixed width that doesn't jaggedly align with the titles.
*   [ ] **Typography:** Increase the font-weight of the Post Titles on the homepage to `600` to separate them from the metadata.
*   [ ] **Footer Cleanup:** Align the footer content better. Remove the "personal" link if it's redundant, or group it properly with Socials.

### Phase 2: The "Craft" (Medium Effort)
*   [ ] **Refined Navigation:**
    *   Use text for all nav items on mobile (there is space for "Home" and "About").
    *   Replace emoji toggle with a clean SVG icon that swaps state.
*   [ ] **Micro-Interactions:**
    *   Add a subtle transition to link underlines or colors.
    *   Add a hover state to the entire post row on the homepage (e.g., a very subtle background fade).
*   [ ] **Dark Mode Refinement:** Ensure the background isn't just "dark grey" but has a slight tint (e.g., slate or warm grey) to feel more premium.

### Phase 3: The "Brand" (High Effort - Optional)
*   [ ] **Distinctive Header:** Create a more deliberate layout for the site title/logo area.
*   [ ] **Hero Section:** Add a small bio/intro blurb on the homepage before the list of posts so new visitors know *who* this is immediately.

---

## Recommendation for Immediate Implementation
I recommend starting with **Phase 1** and **Phase 2 Navigation** items. These will give the biggest "quality of life" boost to the visual design.
