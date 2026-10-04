# ASTANTRA UI/UX Design System

## Brand
- Name: **ASTANTRA**
- Tagline: **Keep Industry Moving.**
- Descriptor: **Industrial Parts · Procurement · Services**
- Tone: precise, practical, industrial and trustworthy without exaggerated claims.
- Prefer restrained editorial layouts, clear hierarchy, useful whitespace and subtle motion. Avoid generic card grids, excessive gradients, unnecessary uppercase eyebrow labels, heavy shadows and decorative animation.
- Never invent testimonials, customer logos, certifications, supplier counts, uptime or security claims.

## Color tokens
| Token | Hex | Usage |
|---|---|---|
| Page background | `#F1F3F5` | Main canvas |
| Secondary surface | `#E7EBEF` | Secondary areas |
| Surface | `#FFFFFF` | Forms/content/tables |
| Primary text | `#17212F` | Headings/body |
| Secondary text | `#5F6B7A` | Supporting text |
| Border | `#D5DCE3` | Dividers/inputs |
| Primary blue | `#1769E0` | Main actions, links, focus |
| Emergency orange | `#E87519` | Emergency-specific actions only |
| Success green | `#18865B` | Success |
| Error red | `#B42318` | Errors |
| Warning amber | `#9A6700` | Warnings |

Check contrast. Do not convey status by color alone or use emergency orange for ordinary actions. Reuse existing CSS variables where possible instead of creating duplicate token systems.

## Layout and components
Use a 4px-based spacing scale (4, 8, 12, 16, 24, 32, 48px). Prefer borders/spacing before shadows. Keep readable type hierarchy. Buttons need clear verbs and focus/hover/disabled states. Forms need labels, suitable input types and field-level/server-side validation. Tables need clear headings and responsive overflow. Empty states must be honest; no fake results or dead buttons.

## Responsive and accessible UI
Check about 360px, 768px, 1024px and desktop. Use semantic headings, labels, keyboard navigation, visible focus, meaningful alt text, adequate contrast and reduced-motion support. Errors must be understandable without color alone.

## Web Forms constraints
Preserve server-control IDs/types, `runat="server"`, validators, validation groups, postbacks, master-page placeholders and handlers unless a coordinated change is reviewed. Check initial load and postback; account for generated client IDs in CSS. A UI change is done only when responsive, accessible and existing behavior still works.
