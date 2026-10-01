# Viva Voce Preparation & Technical Notes

This document contains plain-language technical explanations for each architectural pattern, UI component, and non-trivial code block. Every team member must understand these notes to defend the project during viva examination.

---

## 1. Standing Viva Defense Questions

### Q1: Why does this application not use React, Angular, or Next.js?
**Answer**:
> "SPAREFINDER is built on ASP.NET Web Forms (.NET Framework 4.8) to meet our MCA curriculum requirements and demonstrate strong fundamental software engineering principles. Web Forms provides robust server-side state management, predictable server control lifecycles, and built-in security. By avoiding client-side single-page application (SPA) bloat, we achieve instantaneous initial page renders, minimal client resource usage, and a clear separation between server-side data processing and presentation."

### Q2: Why did you choose direct ADO.NET over an ORM like Entity Framework?
**Answer**:
> "We intentionally chose parameterized ADO.NET (`SqlConnection`, `SqlCommand`, `SqlDataReader`) because it provides maximum execution transparency and direct control over SQL query performance. In academic evaluation, ADO.NET demonstrates our ability to write safe, parameterized database queries that prevent SQL injection, manage explicit connection pooling through `using` blocks, and eliminate hidden ORM query generation overhead."

### Q3: How is the visual design kept distinct from typical AI-generated web templates?
**Answer**:
> "Typical AI templates rely on generic Bootstrap/Tailwind card grids, centered heroes, purple gradients, and Inter/Roboto fonts. In contrast, SPAREFINDER uses an authentic industrial datasheet aesthetic: a calm light cool gray background (`#F1F3F5`), crisp white work surfaces, structured tabular ledgers with 1px hairline rules, monospace data formatting (`IBM Plex Mono`) for OEM part numbers and tolerances, and strict color restraint where orange is strictly isolated to emergency breakdown alerts."

### Q4: How do scroll reveals and animations work without external libraries like GSAP?
**Answer**:
> "We use standard browser-native APIs: CSS transitions combined with a lightweight JavaScript `IntersectionObserver`. When an element enters the viewport, the observer toggles an active class and immediately disconnects (`unobserve`). All transitions animate only GPU-accelerated properties (`transform` and `opacity`), and a full `@media (prefers-reduced-motion: reduce)` block guarantees accessibility for users with vestibular sensitivities."

### Q5: How was frontend redesign performed without breaking backend code-behind?
**Answer**:
> "We treated all server controls (`asp:Button`, `asp:TextBox`, `asp:Repeater`) as immutable contracts. We preserved every `ID`, `runat="server"`, event subscription (`OnClick`), and databinding expression (`<%# Eval(...) %>`). All styling was applied strictly through `CssClass` and external CSS custom properties, ensuring that code-behind compilation and server postbacks remain completely intact."

---

## 2. Technical Feature Entry Template

When a new technical feature or non-trivial technique is introduced, add an entry using this template:

```markdown
### [Feature / Technique Name]
- **Goal (User problem it solves)**:
- **Technical Summary**:
- **Why We Chose It (vs. rejected alternatives)**:
- **How It Works (3–5 lines)**:
- **Where It Lives (File & line/selector)**:
- **What Would Break If Removed**:
- **Likely Faculty Question & Model Answer**:
- **Responsible Student (Owner)**:
```

---

## 3. Initial Technical Entries

### Safe Forward Revert Git Rollback Protocol
- **Goal**: Maintain 100% stable version control and restore approved codebase states without team friction.
- **Technical Summary**: Uses paired forward revert commits (`git revert`) in reverse chronological order instead of destructive history resets.
- **Why We Chose It**: `git reset --hard` and force-pushing rewrite shared commit history on GitHub, causing merge conflicts for collaborators. Forward reverts preserve an uncorrupted audit trail.
- **How It Works**: Git computes the exact mathematical inverse patch of a target commit and records a new commit that un-does the modifications, leaving the repository tree identical to the target state.
- **Where It Lives**: Repository Git commit history.
- **What Would Break If Removed**: Team members' local repositories would diverge, risking accidental re-introduction of unwanted code.
- **Likely Faculty Question**: *"Why didn't you just force-push a hard reset to rollback?"*
- **Model Answer**: *"Force-pushing destroys published history and can break local working copies for other team members. Forward reverting is industry standard because it produces an immutable, reversible audit log of changes."*
- **Responsible Student**: Zed / Team

