<%@ Page Title="Industrial Spare-Part Procurement & Emergency Sourcing" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Industrial spare-part procurement and emergency sourcing portal connecting factories, suppliers, and certified technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ============================================================================ -->
    <!-- 1. EDITORIAL HERO: INDUSTRIAL SOURCING WORKSPACE                             -->
    <!-- Authentic manufacturing context, sharp typography, direct primary actions    -->
    <!-- ============================================================================ -->
    <section class="relative bg-white border-b border-[#CBD5E1] overflow-hidden">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-16">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 items-center">
                
                <!-- Left Column: Editorial Headline & Value Proposition -->
                <div class="lg:col-span-7 space-y-6 text-left">
                    
                    <div class="flex items-center gap-2">
                        <span class="spec-tag spec-tag-blue">
                            <i class="fa-solid fa-industry"></i> B2B INDUSTRIAL PROCUREMENT
                        </span>
                        <span class="text-xs text-[#64748B] font-mono">MCA Academic Demonstration</span>
                    </div>

                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-[#0F172A] leading-tight m-0">
                        Precision Industrial Spare Parts &amp; <span class="text-[#1D4ED8]">Emergency Sourcing</span>
                    </h1>

                    <p class="text-base text-[#475569] leading-relaxed max-w-2xl m-0">
                        A connected digital procurement ecosystem engineered for manufacturing facilities. Locate verified OEM replacement parts, compare regional supplier quotes, and mobilize on-call field technicians before downtime escalates.
                    </p>

                    <!-- Primary Actions -->
                    <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 pt-2">
                        <a href="~/Public/Parts.aspx" runat="server" class="btn-primary text-sm py-3.5 px-6 font-bold shadow-xs">
                            <i class="fa-solid fa-magnifying-glass"></i> Browse Parts Catalog
                        </a>
                        <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-sm py-3.5 px-6 font-bold">
                            <i class="fa-solid fa-bolt"></i> Emergency Breakdown Request
                        </a>
                    </div>

                    <!-- Operational Telemetry Indicators -->
                    <div class="pt-6 border-t border-[#E2E8F0] grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs text-left">
                        <div class="space-y-0.5">
                            <span class="text-[10px] font-mono uppercase text-[#64748B] block">Industrial Coverage</span>
                            <span class="font-bold text-[#0F172A] text-sm font-mono">Gujarat &amp; Maharashtra</span>
                        </div>
                        <div class="space-y-0.5">
                            <span class="text-[10px] font-mono uppercase text-[#64748B] block">Catalog Sourcing</span>
                            <span class="font-bold text-[#0F172A] text-sm font-mono">OEM Indexed Data</span>
                        </div>
                        <div class="space-y-0.5">
                            <span class="text-[10px] font-mono uppercase text-[#64748B] block">Quotation Target</span>
                            <span class="font-bold text-[#1D4ED8] text-sm font-mono">&lt; 2 Hrs Fast-Track</span>
                        </div>
                        <div class="space-y-0.5">
                            <span class="text-[10px] font-mono uppercase text-[#64748B] block">Field Service</span>
                            <span class="font-bold text-[#059669] text-sm font-mono">Certified Engineers</span>
                        </div>
                    </div>

                </div>

                <!-- Right Column: Authentic Editorial Plant Photography -->
                <div class="lg:col-span-5">
                    <div class="relative rounded-2xl overflow-hidden border border-[#CBD5E1] shadow-lg bg-slate-900 group">
                        <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>" 
                             alt="Modern precision CNC manufacturing workshop and industrial maintenance floor" 
                             class="w-full h-[360px] sm:h-[420px] object-cover object-center group-hover:scale-105 transition-transform duration-700 ease-out"
                             loading="eager" />
                        
                        <!-- Overlay Field Note -->
                        <div class="absolute bottom-0 inset-x-0 bg-gradient-to-t from-[#0F172A]/90 via-[#0F172A]/60 to-transparent p-5 text-white">
                            <div class="flex items-center justify-between text-xs mb-1">
                                <span class="font-mono text-[11px] text-slate-300"><i class="fa-solid fa-location-dot text-[#38BDF8] mr-1"></i> Continuous Operations Desk</span>
                                <span class="spec-tag spec-tag-emerald text-[10px]">ACTIVE MONITORING</span>
                            </div>
                            <p class="text-xs text-slate-300 m-0 leading-snug">
                                Connecting heavy manufacturing plants with regional industrial stockists in Gujarat and Maharashtra.
                            </p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 2. PRACTICAL SEARCH BAR & LIVE CATALOG ENTRY POINT                           -->
    <!-- Real ASP.NET search box preserved with unmistakable live vs demo badges      -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-[#F8FAFC] border-b border-[#CBD5E1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            
            <!-- Interactive Search Card -->
            <div class="bg-white rounded-2xl border border-[#CBD5E1] p-6 sm:p-8 shadow-xs space-y-5">
                
                <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-[#E2E8F0] pb-4">
                    <div>
                        <div class="flex items-center gap-2">
                            <span class="spec-tag spec-tag-blue">DIRECT SPECIFICATION SEARCH</span>
                            <span class="text-xs text-[#64748B] font-mono">CROSS-REFERENCED BY PART # OR MACHINE MODEL</span>
                        </div>
                        <h2 class="text-xl font-bold text-[#0F172A] mt-1 m-0">Search Indexed Spare-Parts Catalog</h2>
                    </div>
                    <a href="~/Public/Parts.aspx" runat="server" class="text-xs font-bold text-[#1D4ED8] hover:underline flex items-center gap-1">
                        View Complete 1,400+ Part Index →
                    </a>
                </div>

                <!-- Search Input Group with Preserved Server Controls -->
                <div class="flex flex-col sm:flex-row gap-3">
                    <div class="relative flex-1">
                        <i class="fa-solid fa-magnifying-glass absolute left-4 top-3.5 text-slate-400"></i>
                        <asp:TextBox ID="txtSearchQuery" runat="server" CssClass="w-full pl-11 pr-4 py-3 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" Placeholder="Search by OEM Part # (e.g. 6210-2RS, PART-HYD-001) or Machine Model..."></asp:TextBox>
                    </div>
                    <asp:Button ID="btnSearch" runat="server" Text="Search Catalog" OnClick="btnSearch_Click" CssClass="btn-primary text-sm py-3 px-8 font-bold shrink-0 cursor-pointer" />
                </div>

                <!-- Quick Specification Filters -->
                <div class="flex flex-wrap items-center gap-2 text-xs text-[#64748B] pt-1">
                    <span class="font-bold text-[#0F172A]">Common Inquiries:</span>
                    <a href="~/Public/Parts.aspx?q=bearing" runat="server" class="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">6204-2RS Bearings</a>
                    <a href="~/Public/Parts.aspx?q=hydraulic" runat="server" class="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">Hydraulic Pump 250Bar</a>
                    <a href="~/Public/Parts.aspx?q=servo" runat="server" class="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">7.5kW AC Servo</a>
                    <a href="~/Public/Parts.aspx?q=vfd" runat="server" class="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">15kW VFD Inverter</a>
                </div>

            </div>

            <!-- Featured Component Teaser Grid: Genuine High-Resolution Technical Macro Photography -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-8">
                
                <!-- Component Card 1: Roller Bearings -->
                <div class="surface-card p-6 flex flex-col sm:flex-row gap-5 items-center">
                    <img src="<%= ResolveUrl("~/Content/images/macro_roller_bearing.jpg") %>" 
                         alt="Precision spherical roller bearing and steel gears" 
                         class="w-full sm:w-36 h-36 object-cover rounded-xl border border-[#CBD5E1] shrink-0" 
                         loading="lazy" />
                    <div class="space-y-2 flex-1 text-left">
                        <div class="flex items-center justify-between">
                            <span class="spec-tag spec-tag-amber">SAMPLE DEMONSTRATION RECORD</span>
                            <span class="status-pill status-pill-verified text-[11px]"><i class="fa-solid fa-circle-check text-[9px]"></i> Ready Stock</span>
                        </div>
                        <h3 class="text-base font-bold text-[#0F172A] m-0">Spherical Roller Bearing 6210-2RS</h3>
                        <p class="text-xs text-[#64748B] m-0 leading-relaxed font-mono">
                            Tolerance: ISO P6 | Bore: 50mm | OD: 90mm | High-load industrial spindle applications.
                        </p>
                        <div class="pt-2 flex items-center justify-between border-t border-[#E2E8F0] text-xs">
                            <span class="font-bold text-[#0F172A] font-mono">&#8377;1,850 <span class="text-[10px] text-[#64748B] font-normal">indicative</span></span>
                            <a href="~/Public/Parts.aspx" runat="server" class="text-[#1D4ED8] font-bold hover:underline">Inspect Catalog →</a>
                        </div>
                    </div>
                </div>

                <!-- Component Card 2: Hydraulic High-Pressure Pump -->
                <div class="surface-card p-6 flex flex-col sm:flex-row gap-5 items-center">
                    <img src="<%= ResolveUrl("~/Content/images/hydraulic_pump_assembly.jpg") %>" 
                         alt="Industrial high pressure hydraulic pump test bench" 
                         class="w-full sm:w-36 h-36 object-cover rounded-xl border border-[#CBD5E1] shrink-0" 
                         loading="lazy" />
                    <div class="space-y-2 flex-1 text-left">
                        <div class="flex items-center justify-between">
                            <span class="spec-tag spec-tag-amber">SAMPLE DEMONSTRATION RECORD</span>
                            <span class="status-pill status-pill-verified text-[11px]"><i class="fa-solid fa-circle-check text-[9px]"></i> Ready Stock</span>
                        </div>
                        <h3 class="text-base font-bold text-[#0F172A] m-0">High-Pressure Hydraulic Pump 250Bar</h3>
                        <p class="text-xs text-[#64748B] m-0 leading-relaxed font-mono">
                            Flow: 45 L/min | Max: 250 Bar | Compatible with 500T industrial hydraulic forming presses.
                        </p>
                        <div class="pt-2 flex items-center justify-between border-t border-[#E2E8F0] text-xs">
                            <span class="font-bold text-[#0F172A] font-mono">&#8377;42,500 <span class="text-[10px] text-[#64748B] font-normal">indicative</span></span>
                            <a href="~/Public/Parts.aspx" runat="server" class="text-[#1D4ED8] font-bold hover:underline">Inspect Catalog →</a>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 3. WORKFLOW SEQUENCE: BUYER-TO-SUPPLIER-TO-TECHNICIAN TRIANGULATION         -->
    <!-- Structured process diagram with technical annotations                        -->
    <!-- ============================================================================ -->
    <section class="py-16 bg-white border-b border-[#CBD5E1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
            
            <div class="text-center space-y-2 max-w-2xl mx-auto">
                <span class="spec-tag spec-tag-blue">PROCUREMENT ARCHITECTURE</span>
                <h2 class="text-2xl sm:text-3xl font-black text-[#0F172A] tracking-tight m-0">
                    How SPAREFINDER Connects the Industrial Triad
                </h2>
                <p class="text-xs sm:text-sm text-[#475569] leading-relaxed">
                    A synchronized data handshake uniting plant buyers, certified warehouse stockists, and on-site maintenance engineers.
                </p>
            </div>

            <!-- Annotated Process Diagram -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 relative">
                
                <!-- Stage 1: Factory Buyer -->
                <div class="surface-card p-6 border-l-4 border-l-[#1D4ED8] space-y-4 text-left">
                    <div class="flex items-center justify-between">
                        <span class="spec-tag spec-tag-blue">STAGE 01</span>
                        <div class="w-8 h-8 rounded-lg bg-blue-50 text-[#1D4ED8] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-industry"></i>
                        </div>
                    </div>
                    <h3 class="text-lg font-bold text-[#0F172A] m-0">Factory Requirement</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Plant maintenance logs a stopped machine or maintenance schedule. The buyer queries by OEM part number or issues a structured Request for Quotation (RFQ).
                    </p>
                    <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-[11px] font-mono text-[#334155] space-y-1">
                        <div>&bull; OEM Specification match</div>
                        <div>&bull; Urgency classification (Standard / Critical)</div>
                    </div>
                </div>

                <!-- Stage 2: Verified Supplier -->
                <div class="surface-card p-6 border-l-4 border-l-[#059669] space-y-4 text-left">
                    <div class="flex items-center justify-between">
                        <span class="spec-tag spec-tag-emerald">STAGE 02</span>
                        <div class="w-8 h-8 rounded-lg bg-emerald-50 text-[#059669] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-warehouse"></i>
                        </div>
                    </div>
                    <h3 class="text-lg font-bold text-[#0F172A] m-0">Supplier Quotation</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Regional stockists receive the RFQ notification, confirm physical shelf inventory, and submit itemized quotations with confirmed lead time.
                    </p>
                    <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-[11px] font-mono text-[#334155] space-y-1">
                        <div>&bull; Real-time stock reservation</div>
                        <div>&bull; Freight &amp; transit time transparency</div>
                    </div>
                </div>

                <!-- Stage 3: Field Technician -->
                <div class="surface-card p-6 border-l-4 border-l-[#EA580C] space-y-4 text-left">
                    <div class="flex items-center justify-between">
                        <span class="spec-tag spec-tag-orange">STAGE 03</span>
                        <div class="w-8 h-8 rounded-lg bg-orange-50 text-[#EA580C] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-user-gear"></i>
                        </div>
                    </div>
                    <h3 class="text-lg font-bold text-[#0F172A] m-0">On-Site Commissioning</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        While the part dispatches, nearby specialized technicians (PLC automation, hydraulic alignment, mechanical fitting) are mobilized for rapid installation.
                    </p>
                    <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-[11px] font-mono text-[#334155] space-y-1">
                        <div>&bull; Skill &amp; machine certification match</div>
                        <div>&bull; Pre-arrival breakdown triage</div>
                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 4. MEANINGFUL SUPPLIER & PART COMPARISON PREVIEW MATRIX                       -->
    <!-- Concrete B2B data table layout with actual parameters and honest labeling    -->
    <!-- ============================================================================ -->
    <section class="py-16 bg-[#F8FAFC] border-b border-[#CBD5E1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">
            
            <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                <div class="space-y-1.5 text-left">
                    <span class="spec-tag spec-tag-amber">DEMONSTRATION COMPARISON DATA</span>
                    <h2 class="text-2xl sm:text-3xl font-black text-[#0F172A] tracking-tight m-0">
                        Supplier Quotation &amp; Availability Matrix
                    </h2>
                    <p class="text-xs sm:text-sm text-[#475569] m-0">
                        Illustrating how procurement managers compare stock, pricing, and distance before confirming order dispatch.
                    </p>
                </div>
                <a href="~/Public/Suppliers.aspx" runat="server" class="btn-secondary text-xs py-2 px-4 font-bold shrink-0">
                    Open Supplier Directory →
                </a>
            </div>

            <!-- Responsive Procurement Table -->
            <div class="table-container shadow-xs">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Supplier &amp; Location</th>
                            <th>Status Badge</th>
                            <th>Stock Status</th>
                            <th>Indicative Price</th>
                            <th>Fulfillment Lead Time</th>
                            <th>Distance</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-[#E2E8F0] text-xs">
                        <tr>
                            <td>
                                <strong class="text-[#0F172A] block text-sm">Western Spares Distribution Ltd</strong>
                                <span class="text-[#64748B] font-mono">Pune Industrial Zone, MH</span>
                            </td>
                            <td><span class="status-pill status-pill-demo">Demo Profile</span></td>
                            <td><span class="text-[#059669] font-bold"><i class="fa-solid fa-circle-check mr-1"></i> In Stock (45 Pcs)</span></td>
                            <td class="font-mono font-bold text-sm text-[#0F172A]">&#8377;42,500</td>
                            <td class="font-mono text-[#1D4ED8]">Same-Day Dispatch</td>
                            <td class="font-mono text-[#64748B]">12 km</td>
                            <td><a href="~/Account/Login.aspx" runat="server" class="btn-primary text-xs py-1.5 px-3">Issue RFQ</a></td>
                        </tr>
                        <tr>
                            <td>
                                <strong class="text-[#0F172A] block text-sm">Apex Hydraulic Systems Corp</strong>
                                <span class="text-[#64748B] font-mono">Sanand GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="status-pill status-pill-demo">Demo Profile</span></td>
                            <td><span class="text-[#059669] font-bold"><i class="fa-solid fa-circle-check mr-1"></i> In Stock (18 Pcs)</span></td>
                            <td class="font-mono font-bold text-sm text-[#0F172A]">&#8377;43,100</td>
                            <td class="font-mono text-[#1D4ED8]">Next-Morning Freight</td>
                            <td class="font-mono text-[#64748B]">28 km</td>
                            <td><a href="~/Account/Login.aspx" runat="server" class="btn-primary text-xs py-1.5 px-3">Issue RFQ</a></td>
                        </tr>
                        <tr>
                            <td>
                                <strong class="text-[#0F172A] block text-sm">Industrial Power Transmissions</strong>
                                <span class="text-[#64748B] font-mono">Navi Mumbai MIDC, MH</span>
                            </td>
                            <td><span class="status-pill status-pill-demo">Demo Profile</span></td>
                            <td><span class="text-[#B45309] font-bold"><i class="fa-solid fa-clock mr-1"></i> Backorder (3 Days)</span></td>
                            <td class="font-mono font-bold text-sm text-[#0F172A]">&#8377;41,800</td>
                            <td class="font-mono text-[#64748B]">3 Business Days</td>
                            <td class="font-mono text-[#64748B]">42 km</td>
                            <td><a href="~/Account/Login.aspx" runat="server" class="btn-secondary text-xs py-1.5 px-3">Pre-Order</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 5. HUMAN-CENTERED TECHNICAL FIELD SUPPORT & BREAKDOWN DESK                   -->
    <!-- Authentic field engineering photography and direct hotline                   -->
    <!-- ============================================================================ -->
    <section class="py-16 bg-white border-b border-[#CBD5E1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
                
                <!-- Left: Authentic Technician Photograph -->
                <div class="lg:col-span-5">
                    <div class="rounded-2xl overflow-hidden border border-[#CBD5E1] shadow-md bg-slate-900 group">
                        <img src="<%= ResolveUrl("~/Content/images/technician_plc_service.jpg") %>" 
                             alt="Industrial electrical automation technician diagnosing PLC control cabinet" 
                             class="w-full h-[360px] sm:h-[400px] object-cover object-top group-hover:scale-105 transition-transform duration-700" 
                             loading="lazy" />
                    </div>
                </div>

                <!-- Right: Breakdown Triage & Field Service Integration -->
                <div class="lg:col-span-7 space-y-6 text-left">
                    <div class="flex items-center gap-2">
                        <span class="spec-tag spec-tag-orange"><i class="fa-solid fa-wrench"></i> ON-SITE TECHNICAL EXPERTISE</span>
                        <span class="spec-tag spec-tag-blue">FIELD SERVICE SPECIALISTS</span>
                    </div>

                    <h2 class="text-2xl sm:text-3xl font-black text-[#0F172A] tracking-tight m-0">
                        Parts + Skilled On-Site Labor in One Coordinated Flow
                    </h2>

                    <p class="text-sm text-[#475569] leading-relaxed m-0">
                        Securing a replacement component is only half the battle. When critical equipment fails, you need certified diagnostic engineers who understand PLC ladder logic, hydraulic pressure valves, and motor rewinding.
                    </p>

                    <div class="space-y-3 text-xs">
                        <div class="p-3 bg-[#F8FAFC] rounded-xl border border-[#E2E8F0] flex items-start gap-3">
                            <i class="fa-solid fa-microchip text-[#1D4ED8] text-base shrink-0 mt-0.5"></i>
                            <div>
                                <strong class="text-[#0F172A] block font-bold">Automation &amp; PLC Diagnostics:</strong>
                                Specialists in Allen-Bradley, Siemens S7, Mitsubishi, and Delta motion controllers.
                            </div>
                        </div>
                        <div class="p-3 bg-[#F8FAFC] rounded-xl border border-[#E2E8F0] flex items-start gap-3">
                            <i class="fa-solid fa-gears text-[#B45309] text-base shrink-0 mt-0.5"></i>
                            <div>
                                <strong class="text-[#0F172A] block font-bold">Hydraulic &amp; Mechanical Fitting:</strong>
                                High-pressure line replacement, pump overhaul, laser shaft alignment, and seal fitting.
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 pt-2">
                        <a href="~/Public/Technicians.aspx" runat="server" class="btn-primary text-xs py-3 px-5 font-bold">
                            <i class="fa-solid fa-user-gear"></i> Find Field Technicians
                        </a>
                        <a href="~/Public/Emergency.aspx" runat="server" class="btn-secondary text-xs py-3 px-5 font-bold">
                            <i class="fa-solid fa-triangle-exclamation text-[#EA580C]"></i> Emergency Breakdown Desk
                        </a>
                    </div>

                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 6. CONCISE TRUST & GOVERNANCE ARCHITECTURE                                   -->
    <!-- Transparent verification explanation + MCA academic defense disclosure       -->
    <!-- ============================================================================ -->
    <section class="py-16 bg-[#F8FAFC] border-b border-[#CBD5E1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-10">
            
            <div class="text-center space-y-2 max-w-2xl mx-auto">
                <span class="spec-tag spec-tag-emerald"><i class="fa-solid fa-shield-halved"></i> AUDIT &amp; GOVERNANCE</span>
                <h2 class="text-2xl sm:text-3xl font-black text-[#0F172A] tracking-tight m-0">
                    Platform Verification &amp; Entity Governance
                </h2>
                <p class="text-xs sm:text-sm text-[#475569] leading-relaxed">
                    Designed to ensure legitimate industrial commerce, authentic OEM parts, and transparent accountability across manufacturing plants and vendors.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 text-left">
                
                <div class="surface-card p-6 space-y-3">
                    <span class="spec-tag spec-tag-blue">STAGE 1 &middot; REGISTRATION</span>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">1. Commercial Documentation</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Suppliers and service entities register with verified GSTIN, trade licenses, and authorized distributor credentials for administrator review.
                    </p>
                </div>

                <div class="surface-card p-6 space-y-3">
                    <span class="spec-tag spec-tag-amber">STAGE 2 &middot; PHYSICAL AUDIT</span>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">2. Warehouse &amp; Inventory Audit</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Physical facility check and OEM authorization inspection to ensure stocked parts meet genuine manufacturing tolerances.
                    </p>
                </div>

                <div class="surface-card p-6 space-y-3">
                    <span class="spec-tag spec-tag-emerald">STAGE 3 &middot; ACTIVATION</span>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">3. Verified Status Badging</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Approved entities receive the verified compliance badge, opening access to high-priority emergency breakdown broadcasts and RFQs.
                    </p>
                </div>

            </div>

            <!-- Academic viva transparency note -->
            <div class="bg-amber-50/60 border border-amber-200 rounded-xl p-4 text-xs text-amber-900 flex items-start gap-3">
                <i class="fa-solid fa-circle-info text-amber-700 text-sm mt-0.5 shrink-0"></i>
                <div class="leading-relaxed">
                    <strong>Academic Research &amp; Evaluation Scope:</strong>
                    This portal represents an MCA capstone demonstration. Data displayed within visitor directories consists of curated industrial demonstration profiles. Live commercial payment gateway processing is simulated via mock quotation approval workflows.
                </div>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 7. CLEAR FINAL CALL TO ACTION                                                -->
    <!-- Purpose-driven portal onboarding for industrial buyers & suppliers           -->
    <!-- ============================================================================ -->
    <section class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="bg-gradient-to-r from-slate-900 via-[#1E293B] to-slate-900 text-white rounded-3xl p-8 sm:p-12 shadow-xl flex flex-col lg:flex-row items-start lg:items-center justify-between gap-8 border border-slate-700">
                <div class="space-y-3 max-w-2xl text-left">
                    <span class="spec-tag spec-tag-blue">READY TO STREAMLINE PROCUREMENT?</span>
                    <h2 class="text-2xl sm:text-3xl font-black text-white m-0">
                        Join the SPAREFINDER Industrial Procurement Network
                    </h2>
                    <p class="text-xs sm:text-sm text-slate-300 m-0 leading-relaxed">
                        Whether managing a factory maintenance department or operating an industrial spare-parts warehouse, create your portal account today.
                    </p>
                </div>
                <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 shrink-0 w-full sm:w-auto">
                    <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-3 px-6 font-bold justify-center">
                        <i class="fa-solid fa-user-plus"></i> Create Portal Account
                    </a>
                    <a href="~/Account/Login.aspx" runat="server" class="btn-secondary text-xs py-3 px-6 font-bold justify-center bg-slate-800 text-white border-slate-600 hover:bg-slate-700">
                        <i class="fa-solid fa-right-to-bracket"></i> Sign In to Workspace
                    </a>
                </div>
            </div>
        </div>
    </section>

</asp:Content>

