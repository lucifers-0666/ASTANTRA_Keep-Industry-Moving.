<%@ Page Title="Industrial Spare-Part Procurement & Emergency Sourcing" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Industrial spare-part procurement and emergency sourcing portal connecting factories, suppliers, and certified technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ============================================================================ -->
    <!-- 1. SEARCH-FIRST HERO: INDUSTRIAL SOURCING WORKSPACE                          -->
    <!-- Balanced composition, prominent search input, genuine engineering context     -->
    <!-- ============================================================================ -->
    <section class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-12 lg:py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center">
                
                <!-- Left Column: Purpose, Headline & Primary Action -->
                <div class="lg:col-span-7 space-y-5 text-left">
                    
                    <div class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                        Industrial Sourcing &amp; Maintenance Network
                    </div>

                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-black font-['Archivo',sans-serif] tracking-tight text-[#17212F] leading-tight m-0">
                        Find the right industrial spare part.
                    </h1>

                    <p class="text-sm sm:text-base text-[#5F6B7A] leading-relaxed max-w-2xl m-0">
                        Search verified supplier inventory by OEM part number or machine model, compare quotes, and request emergency maintenance support.
                    </p>

                    <!-- Integrated Functional Search Box (Preserved Server Controls) -->
                    <div class="p-2 sm:p-2.5 bg-white border border-[#D5DCE3] rounded-[3px] shadow-xs space-y-2 mt-2">
                        <div class="flex flex-col sm:flex-row gap-2">
                            <div class="relative flex-1">
                                <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3.5 text-[#7E8C9D] text-xs"></i>
                                <asp:TextBox ID="txtSearchQuery" runat="server" CssClass="w-full pl-9 pr-3 py-2.5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-xs sm:text-sm text-[#17212F] placeholder-[#7E8C9D] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium" Placeholder="Search by OEM Part # (e.g. 6210-2RS, PART-HYD-001) or Machine Model..."></asp:TextBox>
                            </div>
                            <asp:Button ID="btnSearch" runat="server" Text="Search Catalog" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2.5 px-6 font-bold shrink-0 cursor-pointer" />
                        </div>

                        <!-- Quick Specification Filters -->
                        <div class="flex flex-wrap items-center gap-1.5 text-xs text-[#5F6B7A] pt-1 px-1">
                            <span class="font-bold text-[#17212F] text-[11px]">Common Searches:</span>
                            <a href="~/Public/Parts.aspx?cat=Bearings+%26+Power+Transmission" runat="server" class="px-2 py-0.5 rounded-[2px] bg-[#E7EBEF] border border-[#D5DCE3] text-[#2C394B] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors text-[11px] font-mono">Bearings (6210-2RS)</a>
                            <a href="~/Public/Parts.aspx?cat=Hydraulics+%26+Pneumatics" runat="server" class="px-2 py-0.5 rounded-[2px] bg-[#E7EBEF] border border-[#D5DCE3] text-[#2C394B] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors text-[11px] font-mono">Hydraulic Pumps</a>
                            <a href="~/Public/Parts.aspx?cat=Motors+%26+Drives" runat="server" class="px-2 py-0.5 rounded-[2px] bg-[#E7EBEF] border border-[#D5DCE3] text-[#2C394B] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors text-[11px] font-mono">AC Servo Motors</a>
                            <a href="~/Public/Parts.aspx?cat=Electrical+%26+Automation" runat="server" class="px-2 py-0.5 rounded-[2px] bg-[#E7EBEF] border border-[#D5DCE3] text-[#2C394B] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors text-[11px] font-mono">VFD Inverters</a>
                        </div>
                    </div>

                    <!-- Direct Emergency Callout Link -->
                    <div class="flex items-center gap-3 pt-1 text-xs">
                        <span class="text-[#5F6B7A]">Machine breakdown in progress?</span>
                        <a href="~/Public/Emergency.aspx" runat="server" class="font-bold text-[#E87519] hover:underline flex items-center gap-1">
                            <i class="fa-solid fa-bolt"></i> Dispatch Emergency Breakdown Alert →
                        </a>
                    </div>

                </div>

                <!-- Right Column: Authentic Industrial Machining Context -->
                <div class="lg:col-span-5">
                    <div class="relative rounded-[3px] overflow-hidden border border-[#D5DCE3] bg-white p-2">
                        <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>" 
                             alt="Modern precision CNC manufacturing workshop and industrial maintenance floor" 
                             class="w-full h-[320px] sm:h-[380px] object-cover rounded-[2px]" 
                             loading="eager" />
                        
                        <!-- Telemetry Field Note -->
                        <div class="p-3 bg-[#E7EBEF] border-t border-[#D5DCE3] flex items-center justify-between text-xs">
                            <div class="flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-[#18865B] animate-pulse"></span>
                                <span class="text-[11px] text-[#17212F] font-bold">Regional Sourcing Coverage</span>
                            </div>
                            <span class="font-mono text-[11px] text-[#5F6B7A]">Gujarat &amp; Maharashtra Zones</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 2. THREE-STAGE SOURCING WORKFLOW                                             -->
    <!-- Direct, task-focused process from part search to plant installation          -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-white border-b border-[#D5DCE3]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">
            
            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left border-b border-[#D5DCE3] pb-4">
                <div>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                        How Industrial Procurement Works
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                        From identifying replacement specifications to on-site commissioning.
                    </p>
                </div>
                <a href="~/Public/HowItWorks.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline">
                    View Complete Process Workflow →
                </a>
            </div>

            <!-- Connected 3-Step Process Track -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                
                <div class="p-5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#1769E0] bg-[#EAF2FF] px-2.5 py-0.5 rounded-[2px] border border-[#BFDBFE]">STAGE 01</span>
                        <i class="fa-solid fa-barcode text-[#5F6B7A] text-sm"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">1. Match OEM Specifications</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Search by stamped manufacturer part number, machine model, or dimensions to verify mechanical tolerances and equipment compatibility.
                    </p>
                </div>

                <div class="p-5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#1769E0] bg-[#EAF2FF] px-2.5 py-0.5 rounded-[2px] border border-[#BFDBFE]">STAGE 02</span>
                        <i class="fa-solid fa-scale-balanced text-[#5F6B7A] text-sm"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">2. Compare Regional Suppliers</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Review confirmed shelf stock, indicative pricing, and warehouse transit distance. Request binding quotes from stocking vendors.
                    </p>
                </div>

                <div class="p-5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-left space-y-2.5">
                    <div class="flex items-center justify-between">
                        <span class="font-mono text-xs font-bold text-[#18865B] bg-[#E8F5F0] px-2.5 py-0.5 rounded-[2px] border border-[#A7F3D0]">STAGE 03</span>
                        <i class="fa-solid fa-truck-fast text-[#5F6B7A] text-sm"></i>
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
    <!-- 3. LIVE SOURCING DIRECTORY LEDGER                                            -->
    <!-- Ruled tabular preview of verified stockists, parts, and indicative pricing   -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-[#F1F3F5] border-b border-[#D5DCE3]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-6">
            
            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 text-left">
                <div>
                    <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Live Sourcing Preview</span>
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] mt-1 m-0">
                        Regional Inventory &amp; Live Availability
                    </h2>
                    <p class="text-xs text-[#5F6B7A] m-0">
                        Direct stock availability, transit distance, and indicative pricing from regional verified distributors.
                    </p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="~/Public/Parts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5 font-bold">
                        Browse All Parts →
                    </a>
                    <a href="~/Public/Suppliers.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5 font-bold">
                        All Suppliers →
                    </a>
                </div>
            </div>

            <!-- Structured Ruled Table on White Surface -->
            <div class="table-container shadow-xs">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Part / Specification</th>
                            <th>Supplier &amp; Location</th>
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
                                <span class="font-bold text-[#17212F] block">Western Spares Distribution</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Pune Industrial Zone, MH</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1"></i> In Stock (45 Pcs)</span></td>
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
                                <span class="font-bold text-[#17212F] block">Apex Hydraulic &amp; Drives Corp</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Sanand GIDC, Ahmedabad, GJ</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1"></i> In Stock (18 Pcs)</span></td>
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
                                <span class="font-bold text-[#17212F] block">National Bearing Corporation</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Navi Mumbai MIDC, MH</span>
                            </td>
                            <td><span class="text-[#18865B] font-bold"><i class="fa-solid fa-circle-check mr-1"></i> In Stock (120 Pcs)</span></td>
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
                                <span class="font-bold text-[#17212F] block">Western Automation Components</span>
                                <span class="text-[#5F6B7A] font-mono text-[11px]">Vadodara GIDC, GJ</span>
                            </td>
                            <td><span class="text-[#B45309] font-bold"><i class="fa-solid fa-clock mr-1"></i> Backorder (2 Days)</span></td>
                            <td class="font-mono font-bold text-sm text-[#17212F]">&#8377;34,200</td>
                            <td class="font-mono text-[#5F6B7A]">2 Business Days</td>
                            <td class="font-mono text-[#5F6B7A]">42 km</td>
                            <td><a href="~/Public/Parts.aspx?q=vfd" runat="server" class="btn-secondary text-xs py-1.5 px-3">Pre-Order</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </section>

    <!-- ============================================================================ -->
    <!-- 4. CLOSING PORTAL ONBOARDING ACTION                                          -->
    <!-- Clean, professional procurement workspace callout in industrial gray         -->
    <!-- ============================================================================ -->
    <section class="py-12 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="bg-[#F7F8FA] rounded-[3px] p-8 sm:p-10 border border-[#D7DDE4] flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6 shadow-[0_2px_8px_-2px_rgba(20,35,55,0.04)]">
                
                <div class="space-y-1.5 max-w-2xl text-left">
                    <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                        Join the Industrial Procurement Network
                    </h2>
                    <p class="text-xs sm:text-sm text-[#667180] m-0 leading-relaxed">
                        Factory maintenance teams can issue RFQs and track emergency orders. Suppliers and technicians can publish verified inventory and receive direct service requests.
                    </p>
                </div>

                <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 shrink-0 w-full sm:w-auto">
                    <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2.5 px-5 font-bold justify-center">
                        <i class="fa-solid fa-user-plus mr-1.5"></i> Create Account
                    </a>
                    <a href="~/Account/Login.aspx" runat="server" class="btn-secondary text-xs py-2.5 px-5 font-bold justify-center">
                        <i class="fa-solid fa-right-to-bracket mr-1.5"></i> Sign In
                    </a>
                </div>

            </div>
        </div>
    </section>

</asp:Content>

