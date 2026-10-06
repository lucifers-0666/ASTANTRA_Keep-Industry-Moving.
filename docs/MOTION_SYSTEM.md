# Industrial Motion & Micro-Interaction System

This document specifies the motion principles, timing scales, easing functions, and accessibility requirements for ASTANTRA. Motion is treated as an engineering tool to provide spatial continuity and instant state feedback, not as decorative entertainment.

---

## 1. Functional Purposes of Motion

Every animation or transition must serve at least one of these six UX objectives:

1. **Feedback**: Immediate confirmation that the system received an input (e.g., button press depression, focus ring reveal, error shake).
2. **State Changes**: Smooth transformation between interactive states (e.g., active tab indicator movement, accordion expansion, filter rail toggle).
3. **Hierarchy & Guidance**: Directing user attention to critical events (e.g., pulsing green beacon on verified live technicians, subtle alert banner entrance).
4. **Navigation & Continuity**: Maintaining spatial orientation during transitions (e.g., mobile navigation drawer slide, modal backdrop fade).
5. **Affordance**: Subtly indicating interactivity on hover (e.g., 2px card lift, link color shift).
6. **Task Completion Assurance**: Minimizing perceived latency during asynchronous updates (e.g., calm skeleton shimmers).

---

## 2. Motion Duration Scale

Timing is calibrated to human perceptual thresholds. UI transitions must feel instant yet natural:

| Category | Recommended Range | Exact Default | Typical Applications |
| :--- | :--- | :--- | :--- |
| **Fast Micro-Interactions** | 120ms – 180ms | `150ms` (`--duration-fast`) | Button hovers, toggle switches, tab underlines, focus rings, checkbox checkmarks. |
| **Normal UI Transitions** | 180ms – 300ms | `200ms` (`--duration-base`) | Card elevations, dropdown flyouts, accordion disclosure panels, tooltip appearance. |
| **Structural Transitions** | 300ms – 450ms | `300ms` (`--duration-moderate`) | Mobile navigation drawer slide, modal dialog fade/scale, entrance cascade sequences. |

*Rule*: Never use transitions longer than 500ms for standard UI interactions. Do not delay task completion.

---

## 3. Easing Curves

ASTANTRA relies on restrained physics curves modeled after Apple and engineering instrumentation interfaces:

| Easing Token | Cubic-Bezier Value | Behavior & Appropriate Usage |
| :--- | :--- | :--- |
| **`--ease-out`** | `cubic-bezier(0.2, 0.8, 0.2, 1)` | **Standard Project Easing**. Swift departure with gentle, smooth deceleration. Used for buttons, drawers, and modal overlays. |
| **`--ease-apple`** | `cubic-bezier(0.25, 1, 0.5, 1)` | High-fluidity deceleration for larger structural panels and mobile menus. |
| **`--ease-in-out`** | `cubic-bezier(0.4, 0, 0.2, 1)` | Symmetrical acceleration and deceleration. Used for looping status pulses and shimmers. |
| **`linear`** | `linear` | Reserved exclusively for continuous rotation spinners and progress bars. |

---

## 4. Canonical Micro-Interaction Patterns

Defined in [`css/animations.css`](file:///E:/ASP.NET%20MCA/css/animations.css):

### 1. Entrance Cascade (`.u-animate-cascade`)
Used for initial page render or list population to prevent jarring layout pops:
```css
.u-animate-cascade > * {
    animation: u-cascade-fade-in 300ms cubic-bezier(0.16, 1, 0.3, 1) both;
}
.u-animate-cascade > *:nth-child(1) { animation-delay: 40ms; }
.u-animate-cascade > *:nth-child(2) { animation-delay: 80ms; }
.u-animate-cascade > *:nth-child(3) { animation-delay: 120ms; }
.u-animate-cascade > *:nth-child(4) { animation-delay: 160ms; }
```

### 2. Mechanical Error Shake (`.u-shake`)
A tight 2–3px lateral oscillation providing clear haptic-style error feedback on invalid form submission:
```css
@keyframes u-error-shake {
    0%, 100% { transform: translateX(0); }
    20%, 60% { transform: translateX(-3px); }
    40%, 80% { transform: translateX(3px); }
}
.u-shake {
    animation: u-error-shake 250ms ease;
}
```

### 3. Operational Status Pulse Beacon (`.u-pulse-beacon`)
A calm, non-distracting 2.5s glow cycle indicating real-time technician readiness or active connection:
```css
@keyframes u-pulse-glow {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.35; transform: scale(0.85); }
}
.u-pulse-beacon {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: var(--color-status-success);
    box-shadow: 0 0 6px var(--color-status-success);
    animation: u-pulse-glow 2.5s infinite;
}
```

### 4. Hardware-Accelerated Transforms
Always animate `transform` (`translate`, `scale`) and `opacity`. Never animate layout-triggering properties such as `width`, `height`, `top`, `left`, `margin`, or `padding`.

---

## 5. Prohibited Motion Patterns

The following patterns degrade professional credibility and are strictly forbidden:
- **Constant Bouncing**: Bouncing arrows, bouncing icons, or elastic rubber-band effects.
- **Excessive Parallax**: Background imagery scrolling at varying artificial speeds.
- **Distracting Particle Effects**: Floating geometric blobs, confetti, floating dots, or matrix rain.
- **Unnecessary Page Transitions**: Full-screen wipes or 3D flips between page navigations.
- **Animations on Every Element**: Floating cards that drift or tilt on mouse move.
- **Slow Motion**: Animations exceeding 500ms that force the user to wait before clicking.

---

## 6. Accessibility & Reduced Motion

All animated properties must respect user system preferences. The following global rule is mandatory across all stylesheets:

```css
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}
```
When reduced motion is active, components transition instantly without spatial displacement.
