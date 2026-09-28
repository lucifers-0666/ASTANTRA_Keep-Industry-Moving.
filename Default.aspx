<%@ Page Title="Industrial Spare Parts Procurement Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Find industrial spare parts, compare suppliers, and get support when a machine breaks down." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ============================================================================ -->
    <!-- 1. HERO SECTION                                                              -->
    <!-- Clean, restrained industrial B2B composition with subtle entrance animation  -->
    <!-- ============================================================================ -->
    <section class="bg-white border-b border-[#D9DEE5] py-12 lg:py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center">
                
                <!-- Left: Headline, Description & Actions -->
                <div class="lg:col-span-7 space-y-6 text-left hero-entrance-text">
                    <div class="space-y-2">
                        <span class="text-xs font-mono font-bold tracking-wider text-[#1769E0] uppercase block">
                            Industrial Spare Parts Procurement
                        </span>
                        <h1 class="text-3xl sm:text-4xl lg:text-[46px] font-bold text-[#111827] leading-tight m-0">
                            Find the Right Spare Parts.<br />Keep Your Machines Running.
                        </h1>
                    </div>

                    <p class="text-base text-[#5F6B7A] leading-relaxed max-w-xl m-0">
                        Find industrial spare parts, compare suppliers and get procurement support from one platform.
                    </p>

                    <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 pt-1">
                        <a href="~/Public/Parts.aspx" runat="server" class="btn-primary text-sm py-3 px-6">
                            <i class="fa-solid fa-magnifying-glass text-xs"></i> Search Spare Parts
                        </a>
                        <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-sm py-3 px-6">
                            <i class="fa-solid fa-bolt text-xs"></i> Emergency Request
                        </a>
                    </div>
                </div>

                <!-- Right: Authentic Industrial Machinery Image -->
                <div class="lg:col-span-5 hero-entrance-image">
                    <div class="rounded-lg overflow-hidden border border-[#D9DEE5] shadow-xs bg-slate-900">
                        <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>" 
                             alt="Industrial manufacturing machinery and precision maintenance workshop" 
                             class="w-full h-[320px] sm:h-[360px] object-cover object-center" 
                             loading="eager" />
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 2. SEARCH SECTION                                                            -->
    <!-- Focused, functional catalog entry point                                      -->
    <!-- ============================================================================ -->
    <section class="py-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="surface-card p-6 sm:p-8 space-y-4 text-left">
            <div>
                <h2 class="text-xl font-bold text-[#111827] m-0">Find a Spare Part</h2>
                <p class="text-xs sm:text-sm text-[#5F6B7A] mt-1 m-0">
                    Search by part name, OEM part number, or machine model.
                </p>
            </div>

            <!-- Search Field & Button with Preserved ASP.NET Server Controls -->
            <div class="flex flex-col sm:flex-row gap-3 pt-1">
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3 text-slate-400 text-sm"></i>
                    <asp:TextBox ID="txtSearchQuery" runat="server" CssClass="form-input pl-10" Placeholder="Search by part name, part number, or machine..."></asp:TextBox>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search Catalog" OnClick="btnSearch_Click" CssClass="btn-primary shrink-0 text-sm py-2 px-6" />
            </div>

            <!-- Popular Search Queries -->
            <div class="flex flex-wrap items-center gap-2 pt-2 text-xs text-[#5F6B7A]">
                <span class="font-semibold text-[#111827]">Popular:</span>
                <a href="~/Public/Parts.aspx?q=bearing" runat="server" class="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Bearings</a>
                <a href="~/Public/Parts.aspx?q=hydraulic" runat="server" class="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Hydraulic Pump</a>
                <a href="~/Public/Parts.aspx?q=motor" runat="server" class="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Motor</a>
                <a href="~/Public/Parts.aspx?q=valve" runat="server" class="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Valve</a>
                <a href="~/Public/Parts.aspx?q=plc" runat="server" class="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">PLC</a>
            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 3. POPULAR CATEGORIES                                                        -->
    <!-- 6 compact, aligned categories with restrained hover transitions               -->
    <!-- ============================================================================ -->
    <section class="pb-12 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-4">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-bold text-[#111827] m-0">Popular Categories</h2>
            <a href="~/Public/Parts.aspx" runat="server" class="text-xs font-semibold text-[#1769E0] hover:underline">
                View All Categories →
            </a>
        </div>

        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
            <a href="~/Public/Parts.aspx?cat=Bearings%20%26%20Power%20Transmission" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-circle-notch"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Bearings</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">Roller &amp; Ball</span>
            </a>

            <a href="~/Public/Parts.aspx?cat=Hydraulics%20%26%20Pneumatics" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-water"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Hydraulics</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">Pumps &amp; Valves</span>
            </a>

            <a href="~/Public/Parts.aspx?cat=Motors%20%26%20Drives" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-fan"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Motors</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">AC &amp; Servo Drives</span>
            </a>

            <a href="~/Public/Parts.aspx?cat=Electrical%20%26%20Automation" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-microchip"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Automation</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">PLC &amp; Sensors</span>
            </a>

            <a href="~/Public/Parts.aspx?cat=Pumps%20%26%20Valves" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-gears"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Mechanical</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">Gears &amp; Couplings</span>
            </a>

            <a href="~/Public/Parts.aspx?cat=Electrical%20%26%20Automation" runat="server" class="surface-card category-card p-4 text-center block">
                <div class="category-icon w-10 h-10 mx-auto rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-base mb-2">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <span class="text-xs font-bold text-[#111827] block">Electrical</span>
                <span class="text-[11px] text-[#5F6B7A] block mt-0.5">Switchgear &amp; Relays</span>
            </a>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 4. FEATURED SPARE PARTS                                                      -->
    <!-- Exactly 3 clean industrial product cards                                     -->
    <!-- ============================================================================ -->
    <section class="pb-12 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-4">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-bold text-[#111827] m-0">Featured Spare Parts</h2>
            <a href="~/Public/Parts.aspx" runat="server" class="text-xs font-semibold text-[#1769E0] hover:underline">
                Explore All Parts →
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
            
            <!-- Part 1: Roller Bearing -->
            <div class="surface-card group p-5 flex flex-col justify-between space-y-4 text-left">
                <div class="space-y-3">
                    <div class="overflow-hidden rounded border border-[#D9DEE5]">
                        <img src="<%= ResolveUrl("~/Content/images/macro_roller_bearing.jpg") %>" 
                             alt="Spherical Roller Bearing 6210-2RS" 
                             class="w-full h-40 object-cover img-subtle-zoom" 
                             loading="lazy" />
                    </div>
                    <div>
                        <span class="text-[11px] font-mono text-[#5F6B7A] block">OEM Part # 6210-2RS</span>
                        <h3 class="text-base font-bold text-[#111827] m-0 mt-0.5">Spherical Roller Bearing</h3>
                        <p class="text-xs text-[#5F6B7A] m-0 mt-1">Tolerance ISO P6, 50mm bore, high-load spindle use.</p>
                    </div>
                </div>
                <div class="pt-3 border-t border-[#D9DEE5] flex items-center justify-between">
                    <div>
                        <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                        <span class="font-mono font-bold text-base text-[#111827]">&#8377;1,850</span>
                    </div>
                    <a href="~/Public/Parts.aspx?q=6210-2RS" runat="server" class="btn-primary text-xs py-2 px-3">
                        View Details
                    </a>
                </div>
            </div>

            <!-- Part 2: Hydraulic Pump -->
            <div class="surface-card group p-5 flex flex-col justify-between space-y-4 text-left">
                <div class="space-y-3">
                    <div class="overflow-hidden rounded border border-[#D9DEE5]">
                        <img src="<%= ResolveUrl("~/Content/images/hydraulic_pump_assembly.jpg") %>" 
                             alt="High-Pressure Hydraulic Pump 250Bar" 
                             class="w-full h-40 object-cover img-subtle-zoom" 
                             loading="lazy" />
                    </div>
                    <div>
                        <span class="text-[11px] font-mono text-[#5F6B7A] block">OEM Part # PART-HYD-001</span>
                        <h3 class="text-base font-bold text-[#111827] m-0 mt-0.5">High-Pressure Hydraulic Pump</h3>
                        <p class="text-xs text-[#5F6B7A] m-0 mt-1">45 L/min flow rate, max 250 Bar pressure rating.</p>
                    </div>
                </div>
                <div class="pt-3 border-t border-[#D9DEE5] flex items-center justify-between">
                    <div>
                        <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Indicative Price</span>
                        <span class="font-mono font-bold text-base text-[#111827]">&#8377;42,500</span>
                    </div>
                    <a href="~/Public/Parts.aspx?q=PART-HYD-001" runat="server" class="btn-primary text-xs py-2 px-3">
                        View Details
                    </a>
                </div>
            </div>

            <!-- Part 3: AC Servo Motor -->
            <div class="surface-card group p-5 flex flex-col justify-between space-y-4 text-left">
                <div class="space-y-3">
                    <div class="overflow-hidden rounded border border-[#D9DEE5]">
                        <img src="<%= ResolveUrl("~/Content/images/warehouse_inventory_racks.jpg") %>" 
                             alt="7.5kW Industrial AC Servo Motor" 
                             class="w-full h-40 object-cover img-subtle-zoom" 
                             loading="lazy" />
                    </div>
                    <div>
                        <span class="text-[11px] font-mono text-[#5F6B7A] block">OEM Part # MOT-SRV-75</span>
                        <h3 class="text-base font-bold text-[#111827] m-0 mt-0.5">7.5kW Industrial AC Servo Motor</h3>
                        <p class="text-xs text-[#5F6B7A] m-0 mt-1">3000 RPM, IP65 sealed for CNC machine axis drive.</p>
                    </div>
                </div>
                <div class="pt-3 border-t border-[#D9DEE5] flex items-center justify-between">
                    <div>
                        <span class="text-[10px] text-[#5F6B7A] block uppercase font-mono">Availability</span>
                        <span class="text-xs font-semibold text-[#1769E0]">Quote on Request</span>
                    </div>
                    <a href="~/Public/Parts.aspx?q=MOT-SRV-75" runat="server" class="btn-primary text-xs py-2 px-3">
                        View Details
                    </a>
                </div>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 5. HOW IT WORKS                                                              -->
    <!-- Exactly 3 steps in a clean horizontal layout                                 -->
    <!-- ============================================================================ -->
    <section class="pb-12 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-4">
        <h2 class="text-xl font-bold text-[#111827] m-0 text-left">How It Works</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div class="surface-card p-6 space-y-2 text-left">
                <span class="text-xs font-mono font-bold text-[#1769E0] block">STEP 1</span>
                <h3 class="text-base font-bold text-[#111827] m-0">Find a Part</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Search the indexed catalog by OEM part number or machine model to view compatible specifications.
                </p>
            </div>

            <div class="surface-card p-6 space-y-2 text-left">
                <span class="text-xs font-mono font-bold text-[#1769E0] block">STEP 2</span>
                <h3 class="text-base font-bold text-[#111827] m-0">Compare Suppliers</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Evaluate regional stockists on ready shelf inventory, transit distance, and quotation turnaround.
                </p>
            </div>

            <div class="surface-card p-6 space-y-2 text-left">
                <span class="text-xs font-mono font-bold text-[#1769E0] block">STEP 3</span>
                <h3 class="text-base font-bold text-[#111827] m-0">Place an Order</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Request formal quotes, confirm procurement terms, and dispatch on-call technicians if installation is required.
                </p>
            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 6. EMERGENCY SUPPORT CTA                                                     -->
    <!-- Deep navy authority surface with restrained orange emergency action          -->
    <!-- ============================================================================ -->
    <section class="pb-14 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-[#101C2C] text-white rounded-lg p-6 sm:p-8 border border-[#22354E] flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
            <div class="space-y-1.5 text-left max-w-xl">
                <span class="text-xs font-mono font-bold text-[#E87519] uppercase tracking-wider block">
                    Breakdown Support
                </span>
                <h2 class="text-xl sm:text-2xl font-bold text-white m-0">
                    Machine Down? Find Parts and Technical Support Faster.
                </h2>
                <p class="text-xs sm:text-sm text-slate-300 m-0 leading-relaxed">
                    Broadcast urgent replacement requirements to regional stockists and mobilize certified on-call field engineers.
                </p>
            </div>
            <div class="shrink-0">
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-sm py-3 px-6 whitespace-nowrap">
                    <i class="fa-solid fa-triangle-exclamation mr-1.5"></i> Raise Emergency Request
                </a>
            </div>
        </div>
    </section>

</asp:Content>
