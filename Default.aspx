<%@ Page Title="Industrial Spare-Part Procurement & Emergency Sourcing" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="ASTANTRA is a prototype industrial spare-parts sourcing portal for factory maintenance teams." />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ============================================================================ -->
    <!-- SECTION 1: HERO + SEARCH                                                     -->
    <!-- Buyer-first plain language, command search (M1), and inline SVG schematic (M2)-->
    <!-- Preserves txtSearchQuery and btnSearch ASP.NET server controls               -->
    <!-- ============================================================================ -->
    <section class="home-section home-section--gray py-10 lg:py-14" id="searchSection">
        <div class="home-container">
            <div class="hero-grid">

                <!-- Left Column: Copy & Command Search Panel -->
                <div class="hero-copy">
                    <div class="headline-reveal">
                        <span class="section-header__eyebrow">Gujarat Industrial Procurement</span>
                        <h1 class="hero-title">
                            Find a bearing, motor or valve near you.
                        </h1>
                    </div>

                    <p class="hero-subtitle subheadline-reveal">
                        Search sample catalog entries by part number, category, or machine description.
                    </p>

                </div>

                    <!-- Search Formulation Panel (M1 Command Style) -->
                    <div class="hero-search-panel" id="searchPanel">
                        <div class="search-input-group">
                            <!-- Main Text Query Input -->
                            <div class="search-box-wrap">
                                <i class="fa-solid fa-magnifying-glass search-icon-inside" aria-hidden="true"></i>
                                <asp:TextBox ID="txtSearchQuery" runat="server"
                                    CssClass="hero-search-input"
                                    placeholder="Search OEM part # (e.g. 6210-2RS, PART-HYD-001) or machine..."
                                    aria-label="Search by OEM part number or description"></asp:TextBox>
                                <span class="search-shortcut-badge">
                                    <kbd class="search-keyhint" title="Press Ctrl+K or / to focus">Ctrl K</kbd>
                                </span>
                            </div>

                            <!-- Category Filter Dropdown (Client-Side Quick Routing) -->
                            <select id="searchCategory" class="search-filter-select" aria-label="Filter by Component Category" onchange="if(this.value){ window.location.href='<%= ResolveUrl("~/Public/Parts.aspx?cat=") %>' + encodeURIComponent(this.value); }">
                                <option value="">All Categories</option>
                                <option value="Bearings & Power Transmission">Bearings</option>
                                <option value="Motors & Drives">Motors & Drives</option>
                                <option value="Hydraulics & Pneumatics">Hydraulics</option>
                                <option value="Electrical & Automation">Electrical & Switchgear</option>
                                <option value="Pumps & Valves">Pumps & Valves</option>
                            </select>

                            <!-- Location Filter Dropdown -->
                            <select id="searchLocation" class="search-filter-select" aria-label="Filter by Regional Industrial Cluster">
                                <option value="">All Gujarat Hubs</option>
                                <option value="Ahmedabad">Ahmedabad (Naroda / Vatva)</option>
                                <option value="Sanand">Sanand GIDC</option>
                                <option value="Rajkot">Rajkot (Metoda / Shapar)</option>
                                <option value="Vadodara">Vadodara (Makarpura)</option>
                            </select>

                            <!-- ASP.NET Server Button (Preserved Event Wiring) -->
                            <asp:Button ID="btnSearch" runat="server" Text="Search Catalog" OnClick="btnSearch_Click"
                                CssClass="btn btn--primary search-btn-main shrink-0" />
                        </div>

                        <!-- M1 Suggestion Chips (Common Maintenance Inquiries) -->
                        <div class="search-suggestions-row">
                            <span class="search-suggestions-label">Suggestions:</span>
                            <a href="#" class="chip" data-query="6205" data-bearing="6205" data-id="25" data-od="52" data-width="15">6205</a>
                            <a href="#" class="chip" data-query="6208" data-bearing="6208" data-id="40" data-od="80" data-width="18">6208</a>
                            <a href="#" class="chip" data-query="6210-2RS" data-bearing="6210-2RS" data-id="50" data-od="90" data-width="20">6210-2RS</a>
                        </div>

                        <!-- Secondary Emergency Gateway Link -->
                        <div class="search-panel-footer">
                            <span class="search-panel-note">Sample supplier listings for this prototype</span>
                            <a href="~/Public/Emergency.aspx" runat="server" class="search-emergency-link">
                                <i class="fa-solid fa-bolt" aria-hidden="true"></i> Emergency breakdown desk &rarr;
                            </a>
                        </div>
                    </div>

                <!-- Right Column: M2 Inline SVG Engineering Schematic (Under 6 KB) -->
                <div>
                    <div class="schematic-card">
                        <div class="schematic-svg-wrap">
                            <svg viewBox="0 0 380 340" class="w-full h-auto" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Engineering schematic drawing of deep groove ball bearing assembly">
                                <!-- Background Center Reference Grid Lines -->
                                <line x1="190" y1="20" x2="190" y2="300" stroke="#E2E8F0" stroke-width="1" stroke-dasharray="3,3" />
                                <line x1="30" y1="160" x2="350" y2="160" stroke="#E2E8F0" stroke-width="1" stroke-dasharray="3,3" />

                                <g class="bearing-geometry">
                                <!-- Outer Bearing Ring (OD = 90mm) -->
                                <circle cx="190" cy="160" r="120" fill="none" stroke="#2C384A" stroke-width="2.5" class="schematic-draw" />
                                <circle cx="190" cy="160" r="105" fill="none" stroke="#64748B" stroke-width="1" />

                                <!-- Rolling Element Pitch Circle (PCD = 70mm, Dashed) -->
                                <circle cx="190" cy="160" r="85" fill="none" stroke="#94A3B8" stroke-width="1" stroke-dasharray="4,4" />

                                <!-- 8 Rolling Element Spheres (Balls) -->
                                <g fill="#F1F5F9" stroke="#1E293B" stroke-width="1.5">
                                    <circle cx="275" cy="160" r="15" />
                                    <circle cx="250" cy="220" r="15" />
                                    <circle cx="190" cy="245" r="15" />
                                    <circle cx="130" cy="220" r="15" />
                                    <circle cx="105" cy="160" r="15" />
                                    <circle cx="130" cy="100" r="15" />
                                    <circle cx="190" cy="75" r="15" />
                                    <circle cx="250" cy="100" r="15" />
                                </g>

                                <!-- Inner Bearing Ring (ID = 50mm) -->
                                <circle cx="190" cy="160" r="65" fill="none" stroke="#64748B" stroke-width="1" />
                                <circle cx="190" cy="160" r="50" fill="#FFFFFF" stroke="#2C384A" stroke-width="2.5" class="schematic-draw" />

                                <!-- Inner Bore Shaft Hole Crosshairs -->
                                <circle cx="190" cy="160" r="2.5" fill="#1769E0" />
                                </g>

                                <!-- M2 Dimension 1: Outer Diameter (OD: ø90mm) -->
                                <g id="dim-od" class="schematic-dim" stroke="#5F6B7A" stroke-width="1">
                                    <!-- Left Extension Line -->
                                    <line x1="70" y1="160" x2="35" y2="160" />
                                    <line x1="310" y1="160" x2="345" y2="160" />
                                    <!-- Dimension Arrow Line -->
                                    <line x1="190" y1="295" x2="310" y2="295" class="schematic-draw-fast" />
                                    <line x1="190" y1="295" x2="70" y2="295" class="schematic-draw-fast" />
                                    <line x1="70" y1="280" x2="70" y2="305" />
                                    <line x1="310" y1="280" x2="310" y2="305" />
                                    <!-- Arrow Heads -->
                                    <polygon points="70,295 78,292 78,298" fill="#5F6B7A" />
                                    <polygon points="310,295 302,292 302,298" fill="#5F6B7A" />
                                    <text id="schematic-od-label" x="190" y="312" font-family="'IBM Plex Mono', monospace" font-size="10" font-weight="600" fill="#111827" text-anchor="middle">OD ø90.00 mm</text>
                                </g>

                                <!-- M2 Dimension 2: Inner Bore Diameter (ID: ø50mm) -->
                                <g id="dim-id" class="schematic-dim" stroke="#5F6B7A" stroke-width="1">
                                    <line x1="140" y1="160" x2="240" y2="160" stroke="#1769E0" stroke-width="1.25" stroke-dasharray="2,2" />
                                    <line x1="140" y1="150" x2="140" y2="170" stroke="#1769E0" stroke-width="1.5" />
                                    <line x1="240" y1="150" x2="240" y2="170" stroke="#1769E0" stroke-width="1.5" />
                                    <polygon points="140,160 148,157 148,163" fill="#1769E0" />
                                    <polygon points="240,160 232,157 232,163" fill="#1769E0" />
                                    <rect x="157" y="137" width="66" height="16" fill="#FFFFFF" />
                                    <text id="schematic-id-label" x="190" y="149" font-family="'IBM Plex Mono', monospace" font-size="10" font-weight="700" fill="#1769E0" text-anchor="middle">ID ø50.00 mm</text>
                                </g>

                                <!-- M2 Dimension 3: Bearing Width (B: 20mm) -->
                                <g id="dim-w" class="schematic-dim">
                                    <line x1="310" y1="105" x2="334" y2="69" stroke="#5F6B7A" stroke-width="1" />
                                    <rect x="315" y="45" width="45" height="24" rx="2" fill="#F8FAFC" stroke="#D9DEE5" stroke-width="1" />
                                    <text id="schematic-width-label" x="337" y="61" font-family="'IBM Plex Mono', monospace" font-size="9" font-weight="600" fill="#5F6B7A" text-anchor="middle">B: 20 mm</text>
                                </g>
                            </svg>
                        </div>

                        <!-- Hover Callout Triggers (Highlights Dimension Lines in SVG) -->
                        <div class="flex items-center justify-center gap-2 pt-2 border-t border-[#EDF1F5] text-xs">
                            <span class="font-mono text-xs text-[#5F6B7A] cursor-pointer hover:text-[#1769E0] transition-colors" data-dim-target="dim-id">
                                [ID: 50mm]
                            </span>
                            <span class="text-slate-300">&middot;</span>
                            <span class="font-mono text-xs text-[#5F6B7A] cursor-pointer hover:text-[#1769E0] transition-colors" data-dim-target="dim-od">
                                [OD: 90mm]
                            </span>
                            <span class="text-slate-300">&middot;</span>
                            <span class="font-mono text-xs text-[#5F6B7A] cursor-pointer hover:text-[#1769E0] transition-colors" data-dim-target="dim-w">
                                [Width: 20mm]
                            </span>
                        </div>

                        <span id="schematic-caption" class="schematic-caption">Illustrative drawing &middot; Open view &middot; Deep Groove Bearing 6210-2RS</span>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- SECTION 2: CATEGORY INDEX                                                    -->
    <!-- Ruled two-column list (not cards); counts omitted as LATER (M4 interactions) -->
    <!-- ============================================================================ -->
    <section class="home-section home-section--white reveal-on-scroll">
        <div class="home-container">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-3 mb-6 text-left">
                <div>
                    <h2 class="section-header__title">
                        Browse by category
                    </h2>
                    <p class="section-header__desc">
                        Bearings, motors, hydraulics, electrical and more.
                    </p>
                </div>
                <a href="~/Public/Parts.aspx" runat="server" class="btn btn--secondary text-xs shrink-0 self-start sm:self-auto">
                    Full Catalog &rarr;
                </a>
            </div>

            <!-- M4 Ruled Two-Column List (Tint, arrow shift +4px, spec chips fade-in) -->
            <div class="category-index-list">

                <!-- Row 1: Bearings & Power Transmission -->
                <a href="~/Public/Parts.aspx?cat=Bearings+%26+Power+Transmission" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-circle-notch" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Bearings &amp; Power Transmission</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">Deep Groove (6200-6300)</span>
                                <span class="chip text-xs">Spherical Roller</span>
                                <span class="chip text-xs">Pillow Blocks</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

                <!-- Row 2: Motors & Drives -->
                <a href="~/Public/Parts.aspx?cat=Motors+%26+Drives" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-bolt" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Electric Motors &amp; Drives</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">3-Phase AC Induction</span>
                                <span class="chip text-xs">Servo Actuators</span>
                                <span class="chip text-xs">Flange Mount</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

                <!-- Row 3: Hydraulics & Pneumatics -->
                <a href="~/Public/Parts.aspx?cat=Hydraulics+%26+Pneumatics" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-faucet-drip" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Hydraulics &amp; Pneumatics</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">250-350 Bar Piston Pumps</span>
                                <span class="chip text-xs">Directional Valves</span>
                                <span class="chip text-xs">FRLs</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

                <!-- Row 4: Electrical & Switchgear -->
                <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-toggle-on" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Electrical &amp; Switchgear</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">VFD Inverters</span>
                                <span class="chip text-xs">MCCB Breakers</span>
                                <span class="chip text-xs">Power Contactors</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

                <!-- Row 5: Pumps & Valves -->
                <a href="~/Public/Parts.aspx?cat=Pumps+%26+Valves" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-arrows-rotate" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Process Pumps &amp; Valves</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">Chemical Process Pumps</span>
                                <span class="chip text-xs">Cartridge Seals</span>
                                <span class="chip text-xs">Solenoids</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

                <!-- Row 6: Sensors & Instrumentation -->
                <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server" class="category-row group">
                    <div class="category-row__main">
                        <div class="category-row__icon">
                            <i class="fa-solid fa-satellite-dish" aria-hidden="true"></i>
                        </div>
                        <div>
                            <h3 class="category-row__title">Sensors &amp; Encoders</h3>
                            <div class="category-row__specs">
                                <span class="chip text-xs">Inductive M12/M18</span>
                                <span class="chip text-xs">Rotary Encoders</span>
                                <span class="chip text-xs">Optical Optics</span>
                            </div>
                        </div>
                    </div>
                    <div class="category-row__arrow">
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </div>
                </a>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- SECTION 3: PROCESS RAIL (M5)                                                 -->
    <!-- Three steps on one line that animates on scroll; vertical on mobile           -->
    <!-- ============================================================================ -->
    <section class="home-section home-section--gray reveal-on-scroll">
        <div class="home-container">

            <div class="section-header">
                <h2 class="section-header__title">
                    How it works
                </h2>
                <p class="section-header__desc">
                    Search, ask for quotes, order.
                </p>
            </div>

            <!-- M5 Animated Process Rail Container -->
            <div class="process-rail-wrap" aria-label="Search, ask for quotes, order">
                <!-- Connecting Line Across Nodes (Desktop) -->
                <div class="rail-connecting-line">
                    <div class="rail-connecting-line-fill"></div>
                </div>

                <div class="process-rail-track">

                    <!-- Step 1 -->
                    <div class="rail-step-card rail-node">
                        <div class="rail-node-badge">01</div>
                        <h3 class="rail-step-title">Search and compare</h3>
                        <p class="rail-step-desc">
                            Enter a part number, machine model, or dimensions to find sample listings.
                        </p>
                    </div>

                    <!-- Step 2 -->
                    <div class="rail-step-card rail-node">
                        <div class="rail-node-badge">02</div>
                        <h3 class="rail-step-title">Request quotes</h3>
                        <p class="rail-step-desc">
                            Ask suppliers for price, availability, and dispatch details.
                        </p>
                    </div>

                    <!-- Step 3 -->
                    <div class="rail-step-card rail-node">
                        <div class="rail-node-badge">03</div>
                        <h3 class="rail-step-title">Order and fit</h3>
                        <p class="rail-step-desc">
                            Confirm the order and arrange installation support if needed.
                        </p>
                    </div>

                </div>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- SECTION 4: PARTS LEDGER (M6)                                                 -->
    <!-- Ruled tabular data, sticky header, and expandable "other suppliers" drawer   -->
    <!-- Visibly labeled "Sample data" per G4 / G18 governance rules                  -->
    <!-- ============================================================================ -->
    <section class="home-section home-section--white reveal-on-scroll">
        <div class="home-container">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-3 mb-6 text-left">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="badge badge--sample">Sample data</span>
                    </div>
                    <h2 class="section-header__title mt-1">
                        Parts in stock near you
                    </h2>
                    <p class="section-header__desc">
                        Sample availability, indicative prices, and supplier options.
                    </p>
                </div>
                <div class="flex items-center gap-2 self-start sm:self-auto">
                    <div class="ledger-filters" aria-label="Sample parts filters">
                        <button type="button" class="ledger-filter is-active" data-filter="all" aria-pressed="true">All</button>
                        <button type="button" class="ledger-filter" data-filter="in-stock" aria-pressed="false">In stock</button>
                        <button type="button" class="ledger-filter" data-filter="same-day" aria-pressed="false">Same-day</button>
                    </div>
                    <a href="~/Public/Parts.aspx" runat="server" class="btn btn--secondary text-xs">
                        Browse All Parts &rarr;
                    </a>
                </div>
            </div>

            <!-- Ruled Table Container with Horizontal Scroll Isolation -->
            <div class="ledger-card">
                <div class="ledger-table-wrap">
                    <table class="ledger-table">
                        <thead>
                            <tr>
                                <th class="sticky-header">Part Number &amp; Description</th>
                                <th class="sticky-header">Stockist &amp; Hub</th>
                                <th class="sticky-header">Stock Status</th>
                                <th class="sticky-header">Indicative Price</th>
                                <th class="sticky-header">Lead Time</th>
                                <th class="sticky-header text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <!-- Part 1: Hydraulic Pump -->
                            <tr class="ledger-row" data-stock="in-stock same-day">
                                <td>
                                    <span class="ledger-part-no">PART-HYD-001</span>
                                    <span class="ledger-part-desc">High-Pressure Hydraulic Pump 250Bar &middot; 45 L/min</span>
                                </td>
                                <td>
                                    <strong class="ledger-supplier">Apex Industrial Spares</strong>
                                    <span class="ledger-mono">Naroda GIDC, Ahmedabad</span>
                                </td>
                                <td>
                                    <div class="ledger-status">
                                        <span class="status-dot status-dot--in-stock"></span>
                                        <span>In stock - 45</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="ledger-price">&#8377;42,500</span>
                                </td>
                                <td>
                                    <span class="ledger-lead-time">Same-day dispatch</span>
                                </td>
                                <td class="ledger-action-cell">
                                    <button type="button" class="ledger-expand-btn" aria-expanded="false" aria-controls="sub-drawer-1">
                                        <i class="fa-solid fa-chevron-down" aria-hidden="true"></i> Compare
                                    </button>
                                    <a href="~/Public/Parts.aspx?q=hydraulic" runat="server" class="btn btn--primary ledger-action-button">
                                        Request Quote
                                    </a>
                                </td>
                            </tr>
                            <!-- M6 Expandable Row Drawer for Part 1 -->
                            <tr>
                                <td colspan="6" class="p-0">
                                    <div id="sub-drawer-1" class="ledger-expandable-wrapper" aria-hidden="true">
                                        <div class="ledger-expandable-content">
                                            <div class="sub-ledger-box">
                                                <div class="sub-ledger-title">
                                                    <span>Other Regional Suppliers for PART-HYD-001</span>
                                                    <span class="badge badge--sample">Sample data</span>
                                                </div>
                                                <table class="sub-ledger-table">
                                                    <thead>
                                                        <tr class="text-slate-400 font-mono text-[10px]">
                                                            <th>Supplier</th>
                                                            <th>Hub</th>
                                                            <th>Availability</th>
                                                            <th>Unit Price</th>
                                                            <th>Lead Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Gujarat Hydraulic Solutions</td>
                                                            <td class="font-mono">Vatva GIDC, Ahmedabad</td>
                                                            <td><span class="text-[#18865B] font-medium">In Stock (12 Pcs)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;43,200</td>
                                                            <td class="font-mono text-[#5F6B7A]">24 Hours</td>
                                                        </tr>
                                                        <tr>
                                                            <td>Maruti Fluid Power Co.</td>
                                                            <td class="font-mono">Metoda GIDC, Rajkot</td>
                                                            <td><span class="text-[#D97706] font-medium">Pre-Order (3 Days)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;41,800</td>
                                                            <td class="font-mono text-[#5F6B7A]">3 Business Days</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- Part 2: AC Servo Motor -->
                            <tr class="ledger-row" data-stock="in-stock">
                                <td>
                                    <span class="ledger-part-no">PART-MOT-002</span>
                                    <span class="ledger-part-desc">3-Phase AC Servo Motor 7.5kW &middot; 3000 RPM 415V</span>
                                </td>
                                <td>
                                    <strong class="ledger-supplier">Shreeji Motion Systems</strong>
                                    <span class="ledger-mono">Naroda GIDC, Ahmedabad</span>
                                </td>
                                <td>
                                    <div class="ledger-status">
                                        <span class="status-dot status-dot--in-stock"></span>
                                        <span>In stock - 18</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="ledger-price">&#8377;68,000</span>
                                </td>
                                <td>
                                    <span class="ledger-lead-time">Next-day dispatch</span>
                                </td>
                                <td class="ledger-action-cell">
                                    <button type="button" class="ledger-expand-btn" aria-expanded="false" aria-controls="sub-drawer-2">
                                        <i class="fa-solid fa-chevron-down" aria-hidden="true"></i> Compare
                                    </button>
                                    <a href="~/Public/Parts.aspx?q=servo" runat="server" class="btn btn--primary ledger-action-button">
                                        Request Quote
                                    </a>
                                </td>
                            </tr>
                            <!-- M6 Expandable Row Drawer for Part 2 -->
                            <tr>
                                <td colspan="6" class="p-0">
                                    <div id="sub-drawer-2" class="ledger-expandable-wrapper" aria-hidden="true">
                                        <div class="ledger-expandable-content">
                                            <div class="sub-ledger-box">
                                                <div class="sub-ledger-title">
                                                    <span>Other Regional Suppliers for PART-MOT-002</span>
                                                    <span class="badge badge--sample">Sample data</span>
                                                </div>
                                                <table class="sub-ledger-table">
                                                    <thead>
                                                        <tr class="text-slate-400 font-mono text-[10px]">
                                                            <th>Supplier</th>
                                                            <th>Hub</th>
                                                            <th>Availability</th>
                                                            <th>Unit Price</th>
                                                            <th>Lead Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Shreeji Motion Systems</td>
                                                            <td class="font-mono">Makarpura, Vadodara</td>
                                                            <td><span class="text-[#18865B] font-medium">In Stock (6 Pcs)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;69,500</td>
                                                            <td class="font-mono text-[#5F6B7A]">Same-Day</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- Part 3: Deep Groove Ball Bearing -->
                            <tr class="ledger-row" data-stock="in-stock">
                                <td>
                                    <span class="ledger-part-no">PART-BRG-003</span>
                                    <span class="ledger-part-desc">Deep Groove Ball Bearing 6210-2RS &middot; 50x90x20mm</span>
                                </td>
                                <td>
                                    <strong class="ledger-supplier">Gujarat Bearing Corporation</strong>
                                    <span class="ledger-mono">Naroda GIDC, Ahmedabad</span>
                                </td>
                                <td>
                                    <div class="ledger-status">
                                        <span class="status-dot status-dot--in-stock"></span>
                                        <span>In stock - 120</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="ledger-price">&#8377;1,850</span>
                                </td>
                                <td>
                                    <span class="ledger-lead-time">Ready for pickup</span>
                                </td>
                                <td class="ledger-action-cell">
                                    <button type="button" class="ledger-expand-btn" aria-expanded="false" aria-controls="sub-drawer-3">
                                        <i class="fa-solid fa-chevron-down" aria-hidden="true"></i> Compare
                                    </button>
                                    <a href="~/Public/Parts.aspx?q=bearing" runat="server" class="btn btn--primary ledger-action-button">
                                        Request Quote
                                    </a>
                                </td>
                            </tr>
                            <!-- M6 Expandable Row Drawer for Part 3 -->
                            <tr>
                                <td colspan="6" class="p-0">
                                    <div id="sub-drawer-3" class="ledger-expandable-wrapper" aria-hidden="true">
                                        <div class="ledger-expandable-content">
                                            <div class="sub-ledger-box">
                                                <div class="sub-ledger-title">
                                                    <span>Other Regional Suppliers for PART-BRG-003</span>
                                                    <span class="badge badge--sample">Sample data</span>
                                                </div>
                                                <table class="sub-ledger-table">
                                                    <thead>
                                                        <tr class="text-slate-400 font-mono text-[10px]">
                                                            <th>Supplier</th>
                                                            <th>Hub</th>
                                                            <th>Availability</th>
                                                            <th>Unit Price</th>
                                                            <th>Lead Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Gujarat Bearing Corporation</td>
                                                            <td class="font-mono">Shapar-Veraval, Rajkot</td>
                                                            <td><span class="text-[#18865B] font-medium">In Stock (200 Pcs)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;1,820</td>
                                                            <td class="font-mono text-[#5F6B7A]">Ready for Pickup</td>
                                                        </tr>
                                                        <tr>
                                                            <td>Universal Transmissions</td>
                                                            <td class="font-mono">Sanand GIDC</td>
                                                            <td><span class="text-[#18865B] font-medium">In Stock (80 Pcs)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;1,890</td>
                                                            <td class="font-mono text-[#5F6B7A]">24 Hours</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <!-- Part 4: VFD Inverter -->
                            <tr class="ledger-row" data-stock="backorder">
                                <td>
                                    <span class="ledger-part-no">PART-ELE-004</span>
                                    <span class="ledger-part-desc">Industrial VFD Inverter 15kW &middot; 3-Phase 415V 0-400Hz</span>
                                </td>
                                <td>
                                    <strong class="ledger-supplier">Pioneer Power Control</strong>
                                    <span class="ledger-mono">Naroda GIDC, Ahmedabad</span>
                                </td>
                                <td>
                                    <div class="ledger-status ledger-status--backorder">
                                        <span class="status-dot status-dot--backorder"></span>
                                        <span>Backorder - 2 days</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="ledger-price">&#8377;34,200</span>
                                </td>
                                <td>
                                    <span class="ledger-lead-time">2 business days</span>
                                </td>
                                <td class="ledger-action-cell">
                                    <button type="button" class="ledger-expand-btn" aria-expanded="false" aria-controls="sub-drawer-4">
                                        <i class="fa-solid fa-chevron-down" aria-hidden="true"></i> Compare
                                    </button>
                                    <a href="~/Public/Parts.aspx?q=vfd" runat="server" class="btn btn--primary ledger-action-button">
                                        Pre-Order
                                    </a>
                                </td>
                            </tr>
                            <!-- M6 Expandable Row Drawer for Part 4 -->
                            <tr>
                                <td colspan="6" class="p-0">
                                    <div id="sub-drawer-4" class="ledger-expandable-wrapper" aria-hidden="true">
                                        <div class="ledger-expandable-content">
                                            <div class="sub-ledger-box">
                                                <div class="sub-ledger-title">
                                                    <span>Other Regional Suppliers for PART-ELE-004</span>
                                                    <span class="badge badge--sample">Sample data</span>
                                                </div>
                                                <table class="sub-ledger-table">
                                                    <thead>
                                                        <tr class="text-slate-400 font-mono text-[10px]">
                                                            <th>Supplier</th>
                                                            <th>Hub</th>
                                                            <th>Availability</th>
                                                            <th>Unit Price</th>
                                                            <th>Lead Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Pioneer Power Control</td>
                                                            <td class="font-mono">Makarpura, Vadodara</td>
                                                            <td><span class="text-[#18865B] font-medium">In Stock (2 Units)</span></td>
                                                            <td class="font-mono font-bold text-[#111827]">&#8377;35,000</td>
                                                            <td class="font-mono text-[#5F6B7A]">Next-Day</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
                <p class="ledger-empty-state" hidden>No sample parts match this filter.</p>
            </div>

            <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs text-[#5F6B7A] mt-3 px-1 gap-2">
                <span>Indicative wholesale pricing subject to final supplier quotation.</span>
                <span class="font-mono text-xs text-[#111827]">ASTANTRA Procurement Prototype</span>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- SECTION 5: CLOSING (NAVY EMERGENCY BAND + M7 SEGMENTED ONBOARDING BLOCK)     -->
    <!-- Navy emergency band with ONLY orange button on page; WAI-ARIA tab controls  -->
    <!-- ============================================================================ -->
    <section class="home-section home-section--gray reveal-on-scroll">
        <div class="home-container">

            <!-- Navy Emergency Band (The ONLY orange button on the page) -->
            <div class="closing-navy-band">
                <div>
                    <span class="badge badge--emergency mb-2">Priority Breakdown Dispatch</span>
                    <h3 class="closing-navy-title">Critical machine stopped on your plant floor?</h3>
                    <p class="closing-navy-desc">
                        Send an emergency part request to suppliers and request field support.
                    </p>
                </div>
                <div class="shrink-0 w-full sm:w-auto">
                    <a href="~/Public/Emergency.aspx" runat="server" class="btn btn--emergency w-full sm:w-auto text-xs py-2.5 px-5">
                        <i class="fa-solid fa-triangle-exclamation mr-1" aria-hidden="true"></i> Submit Breakdown Alert &rarr;
                    </a>
                </div>
            </div>

            <!-- M7 Segmented Workspace Control: For Factories | For Suppliers -->
            <div class="join-section text-left">
                <div class="join-section__header">
                    <div>
                        <h2 class="text-xl font-bold font-['Archivo',sans-serif] text-[#111827] m-0">
                            Create your account
                        </h2>
                    </div>

                    <!-- M7 Accessible Tab Switcher (role="tablist") -->
                    <div class="segmented-nav" role="tablist" aria-label="Onboarding Role Switcher">
                        <span class="segmented-indicator" aria-hidden="true"></span>
                        <button type="button" id="tab-factories" class="segmented-tab" role="tab" aria-selected="true" aria-controls="panel-factories" tabindex="0">
                            For Factory Teams
                        </button>
                        <button type="button" id="tab-suppliers" class="segmented-tab" role="tab" aria-selected="false" aria-controls="panel-suppliers" tabindex="-1">
                            For Industrial Suppliers
                        </button>
                    </div>
                </div>

                <!-- Panel 1: For Factory Teams (role="tabpanel") -->
                <div id="panel-factories" class="segmented-panel" role="tabpanel" aria-labelledby="tab-factories" aria-hidden="false">
                    <div class="workspace-card-grid">
                        <div class="space-y-2">
                            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#111827] m-0">
                                Plant Maintenance &amp; Procurement Workspaces
                            </h3>
                            <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                                Request quotes, compare sample supplier options, and arrange technician support when needed.
                            </p>
                        </div>
                        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5 justify-end">
                            <a href="~/Account/Register.aspx" runat="server" class="btn btn--primary text-xs py-2 px-4">
                                <i class="fa-solid fa-user-plus mr-1"></i> Create Factory Account
                            </a>
                            <a href="~/Account/Login.aspx" runat="server" class="btn btn--secondary text-xs py-2 px-4">
                                Sign In
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Panel 2: For Industrial Suppliers (role="tabpanel") -->
                <div id="panel-suppliers" class="segmented-panel" role="tabpanel" aria-labelledby="tab-suppliers" aria-hidden="true">
                    <div class="workspace-card-grid">
                        <div class="space-y-2">
                            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#111827] m-0">
                                Distributor Inventory Publishing &amp; Sourcing Hub
                            </h3>
                            <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                                Publish stock information and receive procurement inquiries from factory teams.
                            </p>
                        </div>
                        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5 justify-end">
                            <a href="~/Account/Register.aspx" runat="server" class="btn btn--primary text-xs py-2 px-4">
                                <i class="fa-solid fa-boxes-stacked mr-1"></i> Register as Supplier
                            </a>
                            <a href="~/Public/WhyUs.aspx" runat="server" class="btn btn--secondary text-xs py-2 px-4">
                                Onboarding Standards
                            </a>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </section>
</asp:Content>
