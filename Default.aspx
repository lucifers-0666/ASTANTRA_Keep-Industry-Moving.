<%@ Page Title="Industrial Spare-Part Procurement & Emergency Sourcing" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Industrial spare-parts procurement and emergency sourcing portal connecting factory maintenance teams, verified suppliers, and certified field technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ============================================================================ -->
    <!-- 1. GLOBAL PROCUREMENT SEARCH STRIP                                           -->
    <!-- Positioned directly beneath navbar for high-velocity industrial part lookup  -->
    <!-- Preserves txtSearchQuery and btnSearch ASP.NET server controls               -->
    <!-- ============================================================================ -->
    <section class="global-search-strip">
        <div class="astantra-container space-y-2.5">

            <!-- Main Search Formulation Box -->
            <div class="search-strip-box">
                <div class="search-strip-input-wrap">
                    <div class="search-input-field-container">
                        <i class="fa-solid fa-magnifying-glass search-input-icon" aria-hidden="true"></i>
                        <asp:TextBox ID="txtSearchQuery" runat="server"
                            CssClass="search-strip-input"
                            Placeholder="Search by OEM Part # (e.g. 6210-2RS, PART-HYD-001), description, or machine model..."></asp:TextBox>
                    </div>
                    <asp:Button ID="btnSearch" runat="server" Text="Search Catalog" OnClick="btnSearch_Click"
                        CssClass="btn-primary text-xs py-2.5 px-6 font-bold shrink-0 cursor-pointer w-full sm:w-auto" />
                </div>

                <!-- Common Specification Filters -->
                <div class="search-queries-row">
                    <span class="search-queries-label">Common Queries:</span>
                    <a href="~/Public/Parts.aspx?cat=Bearings+%26+Power+Transmission" runat="server" class="search-chip">Bearings (6210-2RS)</a>
                    <a href="~/Public/Parts.aspx?cat=Hydraulics+%26+Pneumatics" runat="server" class="search-chip">Hydraulic Pumps</a>
                    <a href="~/Public/Parts.aspx?cat=Motors+%26+Drives" runat="server" class="search-chip">AC Induction Motors</a>
                    <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server" class="search-chip">VFD Inverters</a>
                    <a href="~/Public/Parts.aspx?cat=Pumps+%26+Valves" runat="server" class="search-chip">Pneumatic Valves</a>
                </div>
            </div>

            <!-- Trust Bar / Key Technical Guarantees -->
            <div class="search-trust-bar">
                <div class="search-trust-group">
                    <span class="search-trust-item">
                        <i class="fa-solid fa-circle-check text-[#18865B]" aria-hidden="true"></i>
                        <span>Verified Stockists Only</span>
                    </span>
                    <span class="search-trust-item">
                        <i class="fa-solid fa-microchip text-[#1769E0]" aria-hidden="true"></i>
                        <span>OEM Specification Matching</span>
                    </span>
                    <span class="search-trust-item">
                        <i class="fa-solid fa-file-invoice text-[#475569]" aria-hidden="true"></i>
                        <span>Transparent Direct Quotations</span>
                    </span>
                    <span class="search-trust-item">
                        <i class="fa-solid fa-location-dot text-[#E87519]" aria-hidden="true"></i>
                        <span>Proximity in km &amp; Dispatch Time</span>
                    </span>
                </div>
                <div>
                    <a href="~/Public/Emergency.aspx" runat="server" class="search-emergency-link">
                        <i class="fa-solid fa-bolt" aria-hidden="true"></i> Emergency Breakdown Dispatch &rarr;
                    </a>
                </div>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 2. HERO SECTION: INDUSTRIAL SOURCING WORKSPACE                               -->
    <!-- High-clarity editorial focus (~55% copy, ~45% visual) with direct action CTAs-->
    <!-- ============================================================================ -->
    <section class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-12 lg:py-16">
        <div class="astantra-container">
            <div class="hero-split-grid">

                <!-- Left Column: Purpose, Headline & Primary CTAs -->
                <div class="space-y-6 text-left">

                    <div class="inline-flex items-center gap-2 px-2.5 py-1 rounded-[2px] bg-[#E7EBEF] border border-[#D5DCE3] text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                        <span class="w-1.5 h-1.5 rounded-full bg-[#1769E0]"></span>
                        Industrial Spare-Parts &middot; Verified Sourcing
                    </div>

                    <div class="space-y-3">
                        <h1 class="text-3xl sm:text-4xl lg:text-5xl font-black font-['Archivo',sans-serif] tracking-tight text-[#17212F] leading-tight m-0">
                            Find the right industrial spare part with verified lead times.
                        </h1>

                        <p class="text-sm sm:text-base text-[#5F6B7A] leading-relaxed max-w-2xl m-0">
                            Connect factory maintenance and engineering teams directly with verified regional distributors across Gujarat &amp; Maharashtra industrial clusters. Source mission-critical bearings, motors, hydraulics, and switchgear with OEM cross-referencing.
                        </p>
                    </div>

                    <!-- Direct Action CTAs -->
                    <div class="flex flex-wrap items-center gap-3 pt-2">
                        <a href="~/Public/Parts.aspx" runat="server" class="btn-primary text-xs py-3 px-6 font-bold inline-flex items-center gap-2 shadow-xs">
                            <i class="fa-solid fa-layer-group" aria-hidden="true"></i>
                            Browse Parts Catalog &rarr;
                        </a>
                        <a href="~/Public/Emergency.aspx" runat="server" class="btn-secondary text-xs py-3 px-5 font-bold inline-flex items-center gap-2 border-[#E87519]/40 text-[#C25E0E] hover:bg-[#FEF4EC] transition-colors">
                            <i class="fa-solid fa-bolt text-[#E87519]" aria-hidden="true"></i>
                            Dispatch Emergency Breakdown Alert
                        </a>
                    </div>

                    <!-- Key Operating Metrics / Honest Regional Facts -->
                    <div class="pt-4 border-t border-[#D5DCE3] grid grid-cols-3 gap-4 text-left">
                        <div>
                            <div class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F]">50 km</div>
                            <div class="text-[11px] text-[#5F6B7A] font-medium">Regional Dispatch Radius</div>
                        </div>
                        <div>
                            <div class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F]">100%</div>
                            <div class="text-[11px] text-[#5F6B7A] font-medium">GSTIN Verified Stockists</div>
                        </div>
                        <div>
                            <div class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F]">OEM Spec</div>
                            <div class="text-[11px] text-[#5F6B7A] font-medium">Cross-Referenced Parts</div>
                        </div>
                    </div>

                </div>

                <!-- Right Column: Authentic Industrial Machining Context -->
                <div>
                    <div class="relative rounded-[4px] overflow-hidden border border-[#D5DCE3] bg-white p-2 shadow-sm">
                        <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>"
                             alt="Modern precision CNC manufacturing workshop and industrial maintenance floor"
                             class="w-full h-[320px] sm:h-[400px] object-cover rounded-[2px]"
                             loading="eager" />

                        <!-- Telemetry Field Note -->
                        <div class="p-3 bg-[#E7EBEF] border-t border-[#D5DCE3] flex items-center justify-between text-xs">
                            <div class="flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-[#18865B] animate-pulse" aria-hidden="true"></span>
                                <span class="text-[11px] text-[#17212F] font-bold">Regional Sourcing Coverage</span>
                            </div>
                            <span class="font-mono text-[11px] text-[#5F6B7A]">Ahmedabad &middot; Sanand &middot; Rajkot &middot; Vadodara</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 3. POPULAR INDUSTRIAL CATEGORIES (Selective Bento Grid Architecture)         -->
    <!-- Technical component classes mapping to real catalog database filters         -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-white border-b border-[#D5DCE3]">
        <div class="astantra-container space-y-6">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left border-b border-[#D5DCE3] pb-4">
                <div>
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Standardized Engineering Catalog</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0 mt-0.5">
                        Popular Industrial Categories
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                        Procurement categories mapping factory machinery spares, motion drives, and actuation assemblies.
                    </p>
                </div>
                <a href="~/Public/Parts.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 shrink-0">
                    View Complete Catalog &rarr;
                </a>
            </div>

            <!-- Bento Grid of 8 Technical Categories with Varied Spans & Detailed Specs -->
            <div class="bento-grid">

                <!-- Card 1: Featured (Spans 2 columns on lg) - Power Transmission & Bearings -->
                <a href="~/Public/Parts.aspx?cat=Bearings+%26+Power+Transmission" runat="server"
                   class="bento-card bento-card--featured group">
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <div class="w-9 h-9 rounded-[3px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                                <i class="fa-solid fa-circle-notch text-base" aria-hidden="true"></i>
                            </div>
                            <span class="status-pill status-pill-verified text-[10px] font-mono">HIGH DEMAND</span>
                        </div>
                        <div>
                            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                                Bearings &amp; Power Transmission
                            </h3>
                            <p class="text-xs text-[#5F6B7A] m-0 mt-1 leading-relaxed">
                                Precision-grade rotational components engineered for heavy radial/axial loads, continuous plant shafts, and conveyor assemblies. Verified OEM tolerances.
                            </p>
                        </div>
                        <div class="flex flex-wrap gap-1.5 pt-1">
                            <span class="search-chip text-[10px]">Deep Groove (6200-6300)</span>
                            <span class="search-chip text-[10px]">Spherical Roller</span>
                            <span class="search-chip text-[10px]">Pillow Block Units</span>
                            <span class="search-chip text-[10px]">Taper Lock Bushings</span>
                        </div>
                    </div>
                    <span class="text-xs font-mono font-bold text-[#1769E0] mt-4 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 2: Electric Motors & Drives -->
                <a href="~/Public/Parts.aspx?cat=Motors+%26+Drives" runat="server"
                   class="bento-card group">
                    <div class="space-y-2.5">
                        <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                            <i class="fa-solid fa-bolt text-sm" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Electric Motors
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            3-Phase AC induction motors, high-torque servo actuators, and gearboxes.
                        </p>
                        <div class="flex flex-wrap gap-1 pt-0.5">
                            <span class="search-chip text-[10px]">3-Phase AC</span>
                            <span class="search-chip text-[10px]">Flange Mount</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 3: Belts & Pulleys -->
                <a href="~/Public/Parts.aspx?cat=Bearings+%26+Power+Transmission" runat="server"
                   class="bento-card group">
                    <div class="space-y-2.5">
                        <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                            <i class="fa-solid fa-ring text-sm" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Belts &amp; Pulleys
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            Classical V-belts, synchronous timing belts, and precision machined pulleys.
                        </p>
                        <div class="flex flex-wrap gap-1 pt-0.5">
                            <span class="search-chip text-[10px]">Classical V</span>
                            <span class="search-chip text-[10px]">HTD Timing</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 4: Hydraulics & Cylinders -->
                <a href="~/Public/Parts.aspx?cat=Hydraulics+%26+Pneumatics" runat="server"
                   class="bento-card group">
                    <div class="space-y-2.5">
                        <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                            <i class="fa-solid fa-faucet-drip text-sm" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Hydraulic Systems
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            High-pressure piston pumps, tie-rod cylinders, and directional valve manifolds.
                        </p>
                        <div class="flex flex-wrap gap-1 pt-0.5">
                            <span class="search-chip text-[10px]">250-350 Bar</span>
                            <span class="search-chip text-[10px]">Piston Pumps</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 5: Centrifugal & Process Pumps -->
                <a href="~/Public/Parts.aspx?cat=Pumps+%26+Valves" runat="server"
                   class="bento-card group">
                    <div class="space-y-2.5">
                        <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                            <i class="fa-solid fa-arrows-rotate text-sm" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Process Pumps
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            Chemical transfer pumps, mechanical cartridge seals, and cast impellers.
                        </p>
                        <div class="flex flex-wrap gap-1 pt-0.5">
                            <span class="search-chip text-[10px]">Chemical Spec</span>
                            <span class="search-chip text-[10px]">Cartridge Seals</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 6: Industrial Electrical & Switchgear (Wide on lg) -->
                <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server"
                   class="bento-card bento-card--wide group">
                    <div class="space-y-2.5">
                        <div class="flex items-center justify-between">
                            <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                                <i class="fa-solid fa-toggle-on text-sm" aria-hidden="true"></i>
                            </div>
                            <span class="text-[10px] font-mono text-[#5F6B7A]">CONTROL &amp; PROTECTION</span>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Switchgear, VFDs &amp; Motor Control
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            Variable Frequency Drives (VFDs), molded case circuit breakers (MCCB), contactors, and overload protection relays for industrial control panels.
                        </p>
                        <div class="flex flex-wrap gap-1.5 pt-0.5">
                            <span class="search-chip text-[10px]">VFD Inverters</span>
                            <span class="search-chip text-[10px]">MCCB Breakers</span>
                            <span class="search-chip text-[10px]">Power Contactors</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 7: Pneumatic Automation & FRLs (Wide on lg) -->
                <a href="~/Public/Parts.aspx?cat=Hydraulics+%26+Pneumatics" runat="server"
                   class="bento-card bento-card--wide group">
                    <div class="space-y-2.5">
                        <div class="flex items-center justify-between">
                            <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                                <i class="fa-solid fa-wind text-sm" aria-hidden="true"></i>
                            </div>
                            <span class="text-[10px] font-mono text-[#5F6B7A]">AIR PREPARATION</span>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Pneumatic Valves, Cylinders &amp; FRLs
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            Directional control 5/2 &amp; 3/2 solenoid valves, modular air preparation filter-regulators, and quick-connect pneumatic fittings.
                        </p>
                        <div class="flex flex-wrap gap-1.5 pt-0.5">
                            <span class="search-chip text-[10px]">Solenoid Banks</span>
                            <span class="search-chip text-[10px]">Modular FRL Units</span>
                            <span class="search-chip text-[10px]">ISO Cylinders</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

                <!-- Card 8: Industrial Sensors & Encoders (Wide on lg) -->
                <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server"
                   class="bento-card bento-card--wide group">
                    <div class="space-y-2.5">
                        <div class="flex items-center justify-between">
                            <div class="w-8 h-8 rounded-[2px] bg-white group-hover:bg-[#EAF2FF] border border-[#D5DCE3] group-hover:border-[#BFDBFE] flex items-center justify-center text-[#1769E0] transition-colors">
                                <i class="fa-solid fa-satellite-dish text-sm" aria-hidden="true"></i>
                            </div>
                            <span class="text-[10px] font-mono text-[#5F6B7A]">INSTRUMENTATION</span>
                        </div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] group-hover:text-[#1769E0] transition-colors m-0">
                            Proximity Sensors, Encoders &amp; Optics
                        </h3>
                        <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                            Inductive proximity switches (M8, M12, M18), optical through-beam sensors, and incremental rotary encoders for position feedback.
                        </p>
                        <div class="flex flex-wrap gap-1.5 pt-0.5">
                            <span class="search-chip text-[10px]">Inductive M12/M18</span>
                            <span class="search-chip text-[10px]">Rotary Encoders</span>
                            <span class="search-chip text-[10px]">Photoelectric</span>
                        </div>
                    </div>
                    <span class="text-[11px] font-mono font-bold text-[#1769E0] mt-3 block group-hover:translate-x-1 transition-transform">
                        Explore Category &rarr;
                    </span>
                </a>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 4. PROCUREMENT WORKFLOW (OPERATIONAL ARCHITECTURE)                           -->
    <!-- Three-stage operational pipeline from OEM lookup to fitting and dispatch     -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-[#F1F3F5] border-b border-[#D5DCE3]">
        <div class="astantra-container space-y-6">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left border-b border-[#D5DCE3] pb-4">
                <div>
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Operational Architecture</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0 mt-0.5">
                        How Industrial Procurement Works
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                        From identifying replacement specifications to verified freight dispatch and commissioning.
                    </p>
                </div>
                <a href="~/Public/HowItWorks.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 shrink-0">
                    View Complete Process Workflow &rarr;
                </a>
            </div>

            <!-- Connected 3-Step Process Track -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-5">

                <div class="p-5 bg-white border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5 shadow-xs">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#1769E0] bg-[#EAF2FF] px-2.5 py-0.5 rounded-[2px] border border-[#BFDBFE]">STAGE 01</span>
                        <i class="fa-solid fa-barcode text-[#5F6B7A] text-sm" aria-hidden="true"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">1. Match OEM Specifications</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Search by stamped manufacturer part number, machine model, or dimensions to verify mechanical tolerances and equipment compatibility.
                    </p>
                </div>

                <div class="p-5 bg-white border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5 shadow-xs">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#1769E0] bg-[#EAF2FF] px-2.5 py-0.5 rounded-[2px] border border-[#BFDBFE]">STAGE 02</span>
                        <i class="fa-solid fa-scale-balanced text-[#5F6B7A] text-sm" aria-hidden="true"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">2. Compare Regional Suppliers</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Review confirmed shelf stock, indicative pricing, and warehouse transit distance. Request binding quotes from stocking vendors.
                    </p>
                </div>

                <div class="p-5 bg-white border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5 shadow-xs">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#18865B] bg-[#E8F5F0] px-2.5 py-0.5 rounded-[2px] border border-[#A7F3D0]">STAGE 03</span>
                        <i class="fa-solid fa-truck-fast text-[#5F6B7A] text-sm" aria-hidden="true"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">3. Confirm Dispatch &amp; Fitting</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Approve purchase orders for priority freight dispatch and optionally book nearby certified technicians for machine installation.
                    </p>
                </div>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 5. FEATURED URGENT REPLACEMENTS (Adapted from Figma Concept)                  -->
    <!-- Compact engineering replacement cards backed by real catalog parts & specs   -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-white border-b border-[#D5DCE3]">
        <div class="astantra-container space-y-6">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left border-b border-[#D5DCE3] pb-4">
                <div>
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Priority Procurement</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0 mt-0.5">
                        Featured Urgent Replacements with Live Stock
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                        High-demand industrial machinery components verified in regional distributor warehouses.
                    </p>
                </div>
                <span class="text-xs font-mono text-[#5F6B7A]">
                    Sorted by Availability &middot; Gujarat Hubs
                </span>
            </div>

            <!-- 4 Verified Component Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">

                <!-- Part 1: Hydraulic Pump -->
                <div class="p-4 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left flex flex-col justify-between hover:border-[#1769E0] transition-colors">
                    <div class="space-y-2">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-[10px] font-bold text-[#1769E0] bg-white px-2 py-0.5 rounded-[2px] border border-[#BFDBFE]">
                                HYD-SPEC-250
                            </span>
                            <span class="status-pill status-pill-verified text-[10px]">
                                In Stock
                            </span>
                        </div>
                        <div>
                            <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                                High-Pressure Hydraulic Pump
                            </h3>
                            <span class="font-mono text-xs text-[#5F6B7A] block">OEM Ref: PART-HYD-001</span>
                        </div>
                        <p class="text-[11px] text-[#5F6B7A] m-0 leading-relaxed">
                            Axial piston pump 250Bar for industrial hydraulic press lines.
                        </p>
                        <div class="pt-2 border-t border-[#D5DCE3] text-xs space-y-1">
                            <div class="flex justify-between items-center">
                                <span class="text-[#5F6B7A]">Stockist:</span>
                                <span class="font-bold text-[#17212F] text-right truncate max-w-[140px]">Apex Industrial Spares</span>
                            </div>
                            <div class="flex justify-between items-center font-mono">
                                <span class="text-[#5F6B7A]">Lead Time:</span>
                                <span class="text-[#18865B] font-bold">Same-Day Dispatch</span>
                            </div>
                        </div>
                    </div>
                    <div class="pt-3 mt-3 border-t border-[#D5DCE3] flex items-center justify-between">
                        <div>
                            <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                            <span class="font-mono font-bold text-sm text-[#17212F]">&#8377;42,500</span>
                        </div>
                        <a href="~/Public/Parts.aspx?q=hydraulic" runat="server" class="btn-primary text-xs py-1.5 px-3 font-bold">
                            Request Quote
                        </a>
                    </div>
                </div>

                <!-- Part 2: AC Servo Motor -->
                <div class="p-4 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left flex flex-col justify-between hover:border-[#1769E0] transition-colors">
                    <div class="space-y-2">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-[10px] font-bold text-[#1769E0] bg-white px-2 py-0.5 rounded-[2px] border border-[#BFDBFE]">
                                MOT-3PH-7.5K
                            </span>
                            <span class="status-pill status-pill-verified text-[10px]">
                                In Stock
                            </span>
                        </div>
                        <div>
                            <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                                3-Phase AC Servo Motor 7.5kW
                            </h3>
                            <span class="font-mono text-xs text-[#5F6B7A] block">OEM Ref: PART-MOT-002</span>
                        </div>
                        <p class="text-[11px] text-[#5F6B7A] m-0 leading-relaxed">
                            High-torque precision motor for CNC spindle drives and turning lines.
                        </p>
                        <div class="pt-2 border-t border-[#D5DCE3] text-xs space-y-1">
                            <div class="flex justify-between items-center">
                                <span class="text-[#5F6B7A]">Stockist:</span>
                                <span class="font-bold text-[#17212F] text-right truncate max-w-[140px]">Apex Industrial Spares</span>
                            </div>
                            <div class="flex justify-between items-center font-mono">
                                <span class="text-[#5F6B7A]">Lead Time:</span>
                                <span class="text-[#1769E0] font-bold">Next-Morning Freight</span>
                            </div>
                        </div>
                    </div>
                    <div class="pt-3 mt-3 border-t border-[#D5DCE3] flex items-center justify-between">
                        <div>
                            <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                            <span class="font-mono font-bold text-sm text-[#17212F]">&#8377;68,000</span>
                        </div>
                        <a href="~/Public/Parts.aspx?q=servo" runat="server" class="btn-primary text-xs py-1.5 px-3 font-bold">
                            Request Quote
                        </a>
                    </div>
                </div>

                <!-- Part 3: Deep Groove Ball Bearing -->
                <div class="p-4 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left flex flex-col justify-between hover:border-[#1769E0] transition-colors">
                    <div class="space-y-2">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-[10px] font-bold text-[#1769E0] bg-white px-2 py-0.5 rounded-[2px] border border-[#BFDBFE]">
                                BRG-6210-2RS
                            </span>
                            <span class="status-pill status-pill-verified text-[10px]">
                                In Stock
                            </span>
                        </div>
                        <div>
                            <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                                Deep Groove Ball Bearing
                            </h3>
                            <span class="font-mono text-xs text-[#5F6B7A] block">OEM Ref: PART-BRG-003</span>
                        </div>
                        <p class="text-[11px] text-[#5F6B7A] m-0 leading-relaxed">
                            Heavy load sealed bearing 6210-2RS for heavy industrial shafts.
                        </p>
                        <div class="pt-2 border-t border-[#D5DCE3] text-xs space-y-1">
                            <div class="flex justify-between items-center">
                                <span class="text-[#5F6B7A]">Stockist:</span>
                                <span class="font-bold text-[#17212F] text-right truncate max-w-[140px]">Apex Industrial Spares</span>
                            </div>
                            <div class="flex justify-between items-center font-mono">
                                <span class="text-[#5F6B7A]">Lead Time:</span>
                                <span class="text-[#18865B] font-bold">Ready for Pickup</span>
                            </div>
                        </div>
                    </div>
                    <div class="pt-3 mt-3 border-t border-[#D5DCE3] flex items-center justify-between">
                        <div>
                            <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                            <span class="font-mono font-bold text-sm text-[#17212F]">&#8377;1,850</span>
                        </div>
                        <a href="~/Public/Parts.aspx?q=bearing" runat="server" class="btn-primary text-xs py-1.5 px-3 font-bold">
                            Request Quote
                        </a>
                    </div>
                </div>

                <!-- Part 4: VFD Inverter -->
                <div class="p-4 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left flex flex-col justify-between hover:border-[#1769E0] transition-colors">
                    <div class="space-y-2">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-[10px] font-bold text-[#1769E0] bg-white px-2 py-0.5 rounded-[2px] border border-[#BFDBFE]">
                                ELE-VFD-15KW
                            </span>
                            <span class="status-pill status-pill-demo text-[10px]">
                                Backorder
                            </span>
                        </div>
                        <div>
                            <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                                Industrial VFD Inverter 15kW
                            </h3>
                            <span class="font-mono text-xs text-[#5F6B7A] block">OEM Ref: PART-ELE-004</span>
                        </div>
                        <p class="text-[11px] text-[#5F6B7A] m-0 leading-relaxed">
                            Variable Frequency Drive for high-efficiency process motor control.
                        </p>
                        <div class="pt-2 border-t border-[#D5DCE3] text-xs space-y-1">
                            <div class="flex justify-between items-center">
                                <span class="text-[#5F6B7A]">Stockist:</span>
                                <span class="font-bold text-[#17212F] text-right truncate max-w-[140px]">Apex Industrial Spares</span>
                            </div>
                            <div class="flex justify-between items-center font-mono">
                                <span class="text-[#5F6B7A]">Lead Time:</span>
                                <span class="text-[#9A6700] font-bold">2 Business Days</span>
                            </div>
                        </div>
                    </div>
                    <div class="pt-3 mt-3 border-t border-[#D5DCE3] flex items-center justify-between">
                        <div>
                            <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                            <span class="font-mono font-bold text-sm text-[#17212F]">&#8377;34,200</span>
                        </div>
                        <a href="~/Public/Parts.aspx?q=vfd" runat="server" class="btn-secondary text-xs py-1.5 px-3 font-bold">
                            Pre-Order
                        </a>
                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 6. REGIONAL INVENTORY & LIVE AVAILABILITY (THE CORE ASTANTRA TABLE)           -->
    <!-- Ruled tabular ledger of verified stockists, parts, and indicative pricing   -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-[#F1F3F5] border-b border-[#D5DCE3]">
        <div class="astantra-container space-y-6">

            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left">
                <div>
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Live Sourcing Preview</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] mt-1 m-0">
                        Regional Inventory &amp; Live Availability
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-0.5">
                        Direct shelf availability, warehouse transit distance, and indicative pricing from regional verified distributors.
                    </p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="~/Public/Parts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5 font-bold">
                        Browse All Parts &rarr;
                    </a>
                    <a href="~/Public/Suppliers.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5 font-bold">
                        All Suppliers &rarr;
                    </a>
                </div>
            </div>

            <!-- Structured Ruled Table on White Surface -->
            <div class="table-container shadow-xs">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Part / Specification</th>
                            <th>Stockist &amp; Location</th>
                            <th>Stock Status</th>
                            <th>Indicative Price</th>
                            <th>Fulfillment Lead Time</th>
                            <th>Distance</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-[#D5DCE3] text-xs">
                        <tr>
                            <td>
                                <strong class="text-[#17212F] block font-mono font-bold text-xs">PART-HYD-001</strong>
                                <span class="text-[#5F6B7A]">High-Pressure Hydraulic Pump 250Bar</span>
                            </td>
                            <td>
                                <span class="font-bold text-[#17212F] block">Apex Industrial Spares &amp; Bearings Co.</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Naroda GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1" aria-hidden="true"></i> In Stock (45 Pcs)</span></td>
                            <td class="font-mono font-bold text-sm text-[#17212F]">&#8377;42,500</td>
                            <td class="font-mono text-[#1769E0]">Same-Day Dispatch</td>
                            <td class="font-mono text-[#5F6B7A]">12 km</td>
                            <td><a href="~/Public/Parts.aspx?q=hydraulic" runat="server" class="btn-primary text-xs py-1.5 px-3">Inspect Part</a></td>
                        </tr>
                        <tr>
                            <td>
                                <strong class="text-[#17212F] block font-mono font-bold text-xs">PART-MOT-002</strong>
                                <span class="text-[#5F6B7A]">3-Phase AC Servo Motor 7.5kW</span>
                            </td>
                            <td>
                                <span class="font-bold text-[#17212F] block">Apex Industrial Spares &amp; Bearings Co.</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Naroda GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1" aria-hidden="true"></i> In Stock (18 Pcs)</span></td>
                            <td class="font-mono font-bold text-sm text-[#17212F]">&#8377;68,000</td>
                            <td class="font-mono text-[#1769E0]">Next-Morning Freight</td>
                            <td class="font-mono text-[#5F6B7A]">28 km</td>
                            <td><a href="~/Public/Parts.aspx?q=servo" runat="server" class="btn-primary text-xs py-1.5 px-3">Inspect Part</a></td>
                        </tr>
                        <tr>
                            <td>
                                <strong class="text-[#17212F] block font-mono font-bold text-xs">PART-BRG-003</strong>
                                <span class="text-[#5F6B7A]">Spherical Roller Bearing 6210-2RS</span>
                            </td>
                            <td>
                                <span class="font-bold text-[#17212F] block">Apex Industrial Spares &amp; Bearings Co.</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Naroda GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1" aria-hidden="true"></i> In Stock (120 Pcs)</span></td>
                            <td class="font-mono font-bold text-sm text-[#17212F]">&#8377;1,850</td>
                            <td class="font-mono text-[#1769E0]">Ready for Pickup</td>
                            <td class="font-mono text-[#5F6B7A]">15 km</td>
                            <td><a href="~/Public/Parts.aspx?q=bearing" runat="server" class="btn-primary text-xs py-1.5 px-3">Inspect Part</a></td>
                        </tr>
                        <tr>
                            <td>
                                <strong class="text-[#17212F] block font-mono font-bold text-xs">PART-ELE-004</strong>
                                <span class="text-[#5F6B7A]">Industrial VFD Inverter 15kW</span>
                            </td>
                            <td>
                                <span class="font-bold text-[#17212F] block">Apex Industrial Spares &amp; Bearings Co.</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Naroda GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="text-[#9A6700] font-bold"><i class="fa-solid fa-clock mr-1" aria-hidden="true"></i> Backorder (2 Days)</span></td>
                            <td class="font-mono font-bold text-sm text-[#17212F]">&#8377;34,200</td>
                            <td class="font-mono text-[#5F6B7A]">2 Business Days</td>
                            <td class="font-mono text-[#5F6B7A]">42 km</td>
                            <td><a href="~/Public/Parts.aspx?q=vfd" runat="server" class="btn-secondary text-xs py-1.5 px-3">Pre-Order</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Authentic Field Note -->
            <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs text-[#5F6B7A] px-1 gap-2">
                <span>Indicative wholesale pricing subject to final supplier quotation &middot; Stamped physical inventory verified</span>
                <span class="font-mono text-[11px] text-[#17212F]">LocalDB Relational Ledger &middot; ASTANTRA MCA Prototype</span>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 7. REGIONAL SUPPLIER NETWORK & WAREHOUSE CONTEXT                             -->
    <!-- Verified stockists, physical inventory verification, and industrial photo     -->
    <!-- Uses bulletproof .supplier-split-layout to eliminate word-wrapping collapse  -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-white border-b border-[#D5DCE3]">
        <div class="astantra-container space-y-8">

            <div class="supplier-split-layout">

                <!-- Left: Procurement Context Story -->
                <div class="space-y-4 text-left">
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Regional Stockist Network</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                        Verified Industrial Suppliers &amp; Warehousing Hubs
                    </h2>
                    <p class="text-xs sm:text-sm text-[#5F6B7A] leading-relaxed m-0">
                        ASTANTRA connects manufacturing plants directly with verified regional distributors across Ahmedabad, Sanand, Rajkot, and Vadodara industrial clusters. Every registered supplier maintains physical warehouse stock with verified GSTIN compliance.
                    </p>

                    <!-- Real Verified Supplier Highlight Box -->
                    <div class="p-4 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] space-y-2">
                        <div class="flex items-center justify-between">
                            <span class="font-bold text-xs text-[#17212F] flex items-center gap-1.5">
                                <i class="fa-solid fa-warehouse text-[#1769E0]" aria-hidden="true"></i> Featured Verified Stockist
                            </span>
                            <span class="status-pill status-pill-verified text-[10px]">
                                <i class="fa-solid fa-shield-halved text-[9px] text-emerald-600 mr-1" aria-hidden="true"></i> VERIFIED DISTRIBUTOR
                            </span>
                        </div>
                        <h4 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                            Apex Industrial Spares &amp; Bearings Co.
                        </h4>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-[11px] text-[#5F6B7A] pt-1">
                            <div><strong class="text-[#17212F]">Location:</strong> Naroda GIDC, Ahmedabad, GJ</div>
                            <div><strong class="text-[#17212F]">Coverage:</strong> Same-day dispatch within 50km</div>
                            <div><strong class="text-[#17212F]">Specialization:</strong> Bearings, Hydraulics, Motors</div>
                            <div><strong class="text-[#17212F]">Verification:</strong> Physical Stock Audited</div>
                        </div>
                    </div>

                    <div class="flex flex-wrap items-center gap-3 pt-1">
                        <a href="~/Public/Suppliers.aspx" runat="server" class="btn-primary text-xs py-2 px-4 font-bold">
                            Explore Supplier Directory &rarr;
                        </a>
                        <a href="~/Public/WhyUs.aspx" runat="server" class="btn-secondary text-xs py-2 px-4 font-bold">
                            Verification Standards
                        </a>
                    </div>
                </div>

                <!-- Right: High Quality Warehouse Image -->
                <div>
                    <div class="relative rounded-[3px] overflow-hidden border border-[#D5DCE3] bg-white p-2 shadow-xs">
                        <img src="<%= ResolveUrl("~/Content/images/warehouse_inventory_racks.jpg") %>"
                             alt="Organized industrial spare parts warehouse inventory racks with labeled storage bins"
                             class="w-full h-[280px] sm:h-[340px] object-cover rounded-[2px]"
                             loading="lazy" />
                        <div class="p-3 bg-[#E7EBEF] border-t border-[#D5DCE3] flex items-center justify-between text-xs">
                            <span class="font-bold text-[#17212F] text-[11px]">Physical Shelf Storage Audit</span>
                            <span class="font-mono text-[11px] text-[#5F6B7A]">Direct OEM Packaging Verification</span>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 8. DUAL-ROLE ONBOARDING & PORTAL TERMINAL ACCESS                             -->
    <!-- Purpose-built side-by-side workspace action for buyers and suppliers         -->
    <!-- ============================================================================ -->
    <section class="py-14 bg-white">
        <div class="astantra-container space-y-6">

            <div class="text-left border-b border-[#D5DCE3] pb-4">
                <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Enterprise Onboarding</span>
                <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0 mt-0.5">
                    Join the Industrial Procurement Network
                </h2>
                <p class="text-xs sm:text-sm text-[#5F6B7A] m-0 mt-1">
                    Select your operational role to access dedicated industrial workspaces, RFQ dispatch, and verified inventory tools.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                <!-- Card 1: Factory Maintenance & Procurement Teams -->
                <div class="p-6 sm:p-7 bg-[#F8FAFC] border border-[#D5DCE3] rounded-[4px] text-left flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors shadow-xs">
                    <div class="space-y-2.5">
                        <div class="card-icon-box">
                            <i class="fa-solid fa-industry" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                            For Factory Maintenance Teams
                        </h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Issue urgent breakdown RFQs to verified regional stockists, compare quotes with guaranteed lead times, and dispatch certified field technicians with live tracking.
                        </p>
                    </div>
                    <div class="flex flex-wrap items-center gap-2.5 pt-2 border-t border-[#E2E8F0]">
                        <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2 px-4 font-bold inline-flex items-center gap-1.5">
                            <i class="fa-solid fa-user-plus text-[11px]" aria-hidden="true"></i> Create Factory Account
                        </a>
                        <a href="~/Account/Login.aspx" runat="server" class="btn-secondary text-xs py-2 px-4 font-bold inline-flex items-center gap-1.5">
                            <i class="fa-solid fa-right-to-bracket text-[11px]" aria-hidden="true"></i> Sign In to Terminal
                        </a>
                    </div>
                </div>

                <!-- Card 2: Industrial Suppliers & Stockists -->
                <div class="p-6 sm:p-7 bg-[#F8FAFC] border border-[#D5DCE3] rounded-[4px] text-left flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors shadow-xs">
                    <div class="space-y-2.5">
                        <div class="card-icon-box">
                            <i class="fa-solid fa-warehouse" aria-hidden="true"></i>
                        </div>
                        <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                            For Industrial Suppliers &amp; Stockists
                        </h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Publish verified physical warehouse inventory, receive qualified RFQ enquiries from regional manufacturing plants, and expand distribution across GIDC industrial clusters.
                        </p>
                    </div>
                    <div class="flex flex-wrap items-center gap-2.5 pt-2 border-t border-[#E2E8F0]">
                        <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2 px-4 font-bold inline-flex items-center gap-1.5">
                            <i class="fa-solid fa-boxes-stacked text-[11px]" aria-hidden="true"></i> Register as Supplier
                        </a>
                        <a href="~/Public/WhyUs.aspx" runat="server" class="btn-secondary text-xs py-2 px-4 font-bold inline-flex items-center gap-1.5">
                            Onboarding Standards
                        </a>
                    </div>
                </div>

            </div>

        </div>
    </section>

</asp:Content>
