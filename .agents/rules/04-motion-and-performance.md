# 04 — Motion, Animation & Performance Standards

Motion in SPAREFINDER must guide, orient, or provide feedback. If an animation only exists for visual decoration, it must be removed. The interface must run smoothly on mid-range student laptops and mobile devices.

---

## 1. Permitted Micro-Interactions & Transitions

- **Interactive Hover & Focus**: Fast, crisp transitions (150ms) on links, button borders, and input rings.
- **Button Feedback**: Subtle active press transformation (`transform: translateY(1px)`).
- **Scroll Reveals**: Single-pass entry reveal (fade + 12–16px upward translation). Never re-trigger on reverse scroll.
- **Process Line Drawing**: Restrained SVG `stroke-dashoffset` animation illustrating procurement flow.
- **Emergency Breakdown Alert**: One calm, deliberate subtle pulse animation on emergency status indicators. No other element may pulse.
- **Sticky Navigation**: Gentle height/shadow contraction when scrolling past hero section.

---

## 2. Prohibited Animation Patterns

- **Heavy Animation Libraries**: No GSAP, Velocity, Anime.js, or Framer-style runtimes.
- **Distracting Visual Effects**: No scroll-jacking, mouse-follow trails, particle systems, 3D WebGL, or auto-playing background media.
- **Layout Property Animation**: Never animate layout-triggering properties (`width`, `height`, `top`, `left`, `margin`, `padding`). Animate only GPU-composited properties: `transform` and `opacity`.
- **Indiscriminate Transitions**: Never write `transition: all`. Always specify the exact properties (e.g., `transition: border-color 150ms ease, box-shadow 150ms ease`).

---

## 3. Mandatory Accessibility: `prefers-reduced-motion`

Every stylesheet defining keyframe animations or transitions must include the universal accessibility override:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
  .reveal {
    opacity: 1 !important;
    transform: none !important;
  }
}
```

---

## 4. Performance & Core Web Vitals Budget

- **Target Metrics**:
  - Largest Contentful Paint (LCP): $\le 2.5\text{s}$
  - Cumulative Layout Shift (CLS): $< 0.1$
  - Interaction to Next Paint (INP): $\le 200\text{ms}$
- **Script Footprint**: Design-related client JavaScript must remain lightweight (under 10 KB unminified vanilla JS in `Content/js/site.js`).
- **Font Optimization**: Maximum 3 font families (Archivo, IBM Plex Sans, IBM Plex Mono) using `font-display: swap` and preconnect links.
- **Image Integrity**: Explicit `width` and `height` attributes on all image tags to prevent layout shift; `loading="lazy"` on below-the-fold media.

