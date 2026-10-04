# 05 — ASP.NET Web Forms Safety & Control Preservation

SPAREFINDER is an existing, compiled ASP.NET Web Forms project. Frontend styling must never compromise or break server lifecycle controls, event handlers, or page state.

---

## 1. Inspection Before Editing Any `.aspx` or `.master` File

1. **Read Code-Behind First**: Open the corresponding `.aspx.cs` (in read-only mode) and catalog all server controls:
   - Control IDs (e.g., `btnSearch`, `rptParts`, `txtPartNumber`).
   - Server-side event handlers (e.g., `OnClick="btnSearch_Click"`, `OnItemCommand="..."`).
   - Data-bound containers (`asp:Repeater`, `asp:GridView`, `asp:ListView`).
   - Server validators (`asp:RequiredFieldValidator`, `asp:RegularExpressionValidator`).
2. **Catalog ContentPlaceHolders**: Identify all `<asp:ContentPlaceHolder>` regions exposed by `MasterPages/Site.Master` (`head`, `MainContent`, `ScriptsContent`).
3. **Document Preserved Elements**: Include the preserved control IDs in the task implementation plan.

---

## 2. Immutable Server Control Rules

- **Preserve IDs and Events**: Never rename, remove, or alter the `ID` or event attributes of any `runat="server"` control. Doing so breaks code-behind compilation and event binding.
- **Styling Hooks**: Apply styling exclusively through `CssClass="..."` on server controls or `class="..."` on standard HTML elements.
- **Dynamic Client IDs**: Do not target auto-generated client IDs (e.g., `#ctl00_MainContent_txtPart`) in CSS or JavaScript, as these change across master pages. Use semantic CSS classes or explicit attributes.
- **Single Server Form**: Exactly one `<form runat="server">` must wrap the page content (managed in `Site.Master`). Never introduce nested form tags.
- **Server Lifecycle State**: Do not modify or disable `ViewState`, `AutoPostBack`, or validation group associations.
- **Data Binding Expressions**: In `asp:Repeater` or `asp:ListView` templates, preserve all data-binding expressions (`<%# Eval("PartName") %>` or `<%#: Eval("PartName") %>`). Do not remove or alter bound field names.
- **Virtual Path Resolution**: Always use application-relative paths (`~/Content/...`) with `ResolveUrl()` or `runat="server"` elements so assets load reliably from root (`Default.aspx`) and subfolders (`Public/`, `Account/`, `Factory/`).

---

## 3. Modular Asset Separation

- **Shared Assets (Site.Master)**: Master page owns global `<head>` tags (fonts, core tokens, base CSS), sticky navigation, footer, and the closing `site.js` include.
- **Page-Specific CSS**: Public page stylesheets must reside in `Content/css/public/<page>.css` and be injected via `<asp:Content ContentPlaceHolderID="head">`.
- **Replacing Legacy CSS**: Never delete old CSS classes until a project-wide search confirms they are not referenced in other master pages, views, or code-behind files.

---

## 4. Post-Edit Verification Checklist

After editing any `.aspx` or `.master` file, verify:
- [ ] Solution compiles cleanly with zero errors (`MSBuild`).
- [ ] Server buttons post back properly and trigger code-behind event handlers.
- [ ] Required field validators still prevent invalid form submission.
- [ ] Dynamic data repeaters still render bound database or demo records.
- [ ] Responsive layout adapts across mobile (360px), tablet (768px), and desktop (1280px+).

