<%@ Page Title="How It Works - Industrial Procurement Workflow" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HowItWorks.aspx.cs" Inherits="IndustrialSparePartPortal.Public.HowItWorks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Step-by-step industrial spare-part sourcing, supplier RFQ quotation, and emergency breakdown protocol workflow." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                Procurement Workflow
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                How Industrial Procurement Works
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                A structured digital workflow connecting plant maintenance departments, regional spare-part stockists, and on-site service engineers to eliminate machine downtime.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-10">
        
        <!-- 2. Visual Context Section -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-center">
            <div class="lg:col-span-5">
                <div class="rounded-[3px] overflow-hidden border border-[#D7DDE4] bg-white p-2 shadow-xs">
                    <img src="<%= ResolveUrl("~/Content/images/warehouse_inventory_racks.jpg") %>" 
                         alt="Organized heavy industrial spare parts warehouse racks with parts bins" 
                         class="w-full h-[240px] sm:h-[280px] object-cover rounded-[2px]" 
                         loading="lazy" />
                </div>
            </div>
            <div class="lg:col-span-7 space-y-3 text-left">
                <span class="text-xs font-mono font-bold text-[#1769E0] tracking-wider uppercase">Core Workflow</span>
                <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                    From Component Failure to Verified Commissioning
                </h2>
                <p class="text-xs sm:text-sm text-[#667180] leading-relaxed m-0">
                    Traditional maintenance sourcing relies on unrecorded phone calls, approximate descriptions, and uncertain distributor inventory. ASTANTRA replaces guesswork with verified OEM part indexing, direct RFQ quotations, and certified technician dispatch.
                </p>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1 text-xs">
                    <div class="p-3 bg-[#F7F8FA] rounded-[3px] border border-[#D7DDE4]">
                        <span class="text-[#1769E0] font-bold block text-xs uppercase tracking-wider font-mono">OEM Code Verification</span>
                        <span class="text-[#667180] mt-0.5 block">Search by stamped bearing, seal, valve, or sensor code to eliminate mismatch returns.</span>
                    </div>
                    <div class="p-3 bg-[#F7F8FA] rounded-[3px] border border-[#D7DDE4]">
                        <span class="text-[#16845B] font-bold block text-xs uppercase tracking-wider font-mono">Regional Stock Visibility</span>
                        <span class="text-[#667180] mt-0.5 block">Compare suppliers by physical location, shelf inventory, and dispatch lead time.</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Connected Three-Stage Procurement Workflow -->
        <div class="space-y-4 text-left">
            <div class="space-y-1">
                <span class="text-xs font-mono font-bold text-[#1769E0] tracking-wider uppercase">Three-Stage Process</span>
                <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                    The Procurement Journey
                </h2>
                <p class="text-xs sm:text-sm text-[#667180] m-0">
                    Every procurement request moves through three transparent stages to ensure the right part arrives at the right machine.
                </p>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-5">
                
                <!-- Stage 1 -->
                <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] border-t-4 border-t-[#1769E0] flex flex-col justify-between space-y-4">
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-xs font-bold text-[#1769E0] bg-[#EAF2FF] px-2 py-0.5 rounded-[2px]">STAGE 01</span>
                            <span class="text-xs text-[#8792A0] font-mono">Identification</span>
                        </div>
                        <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                            Specification Check &amp; Compatibility Matching
                        </h3>
                        <p class="text-xs text-[#667180] leading-relaxed m-0">
                            The plant maintenance engineer notes the equipment nameplate details and stamped part numbers (e.g. 6210-2RS bearing, 24V DC solenoid valve). Search the catalog to verify mechanical tolerances, shaft diameters, and electrical ratings.
                        </p>
                    </div>
                    <div class="pt-3 border-t border-[#EDF1F5] text-[11px] text-[#5F6B7A]">
                        <strong class="text-[#202833] block mb-0.5 font-bold">Key Outcome:</strong>
                        Confirmed OEM part number and verified technical datasheet match.
                    </div>
                </div>

                <!-- Stage 2 -->
                <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] border-t-4 border-t-[#16845B] flex flex-col justify-between space-y-4">
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-xs font-bold text-[#16845B] bg-[#E8F5F0] px-2 py-0.5 rounded-[2px]">STAGE 02</span>
                            <span class="text-xs text-[#8792A0] font-mono">Quotation</span>
                        </div>
                        <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                            Multi-Vendor RFQ &amp; Terms Comparison
                        </h3>
                        <p class="text-xs text-[#667180] leading-relaxed m-0">
                            Submit a digital Request for Quote (RFQ) specifying required quantity, delivery urgency, and plant receiving address. Regional stockists respond with confirmed shelf stock, itemized pricing, and freight delivery schedules.
                        </p>
                    </div>
                    <div class="pt-3 border-t border-[#EDF1F5] text-[11px] text-[#5F6B7A]">
                        <strong class="text-[#202833] block mb-0.5 font-bold">Key Outcome:</strong>
                        Transparent price comparison matrix with confirmed delivery timelines.
                    </div>
                </div>

                <!-- Stage 3 -->
                <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] border-t-4 border-t-[#E87519] flex flex-col justify-between space-y-4">
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="font-mono text-xs font-bold text-[#E87519] bg-[#FEF4EC] px-2 py-0.5 rounded-[2px]">STAGE 03</span>
                            <span class="text-xs text-[#8792A0] font-mono">Dispatch &amp; Fitting</span>
                        </div>
                        <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                            Direct Dispatch &amp; Field Commissioning
                        </h3>
                        <p class="text-xs text-[#667180] leading-relaxed m-0">
                            Once an order is confirmed, the supplier dispatches the verified component with test documentation. For complex installations, maintenance managers can book an on-call certified technician to inspect, fit, and align the unit.
                        </p>
                    </div>
                    <div class="pt-3 border-t border-[#EDF1F5] text-[11px] text-[#5F6B7A]">
                        <strong class="text-[#202833] block mb-0.5 font-bold">Key Outcome:</strong>
                        Rapid plant restoration with certified technician sign-off.
                    </div>
                </div>

            </div>
        </div>

        <!-- 4. Current Visitor Experience vs Account-Enabled Portal Features -->
        <div class="surface-card bg-white p-6 rounded-[3px] border border-[#D7DDE4] space-y-4 text-left shadow-xs">
            <div class="space-y-1">
                <span class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">Platform Scope &amp; Availability</span>
                <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                    What You Can Do Today vs. Account-Enabled Features
                </h3>
                <p class="text-xs text-[#667180] m-0">
                    ASTANTRA is being released in structured milestones. Here is what is active for public visitors today and what unlocks with a registered account.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-1">
                <!-- Available Today -->
                <div class="p-4 bg-[#F7F8FA] rounded-[3px] border border-[#D7DDE4] space-y-2.5">
                    <div class="flex items-center gap-2">
                        <span class="w-2.5 h-2.5 rounded-full bg-[#16845B]"></span>
                        <strong class="text-xs font-bold text-[#202833] uppercase tracking-wider font-mono">Available Now (Public Visitor)</strong>
                    </div>
                    <ul class="text-xs text-[#5F6B7A] space-y-1.5 pl-4 list-disc m-0">
                        <li>Browse indexed industrial spare parts catalog by category and part number.</li>
                        <li>Search verified regional supplier directory by industrial hub and product line.</li>
                        <li>Explore certified field service technicians by mechanical/electrical discipline.</li>
                        <li>Draft emergency breakdown notifications with equipment nameplate data.</li>
                    </ul>
                </div>

                <!-- Account-Enabled Portal -->
                <div class="p-4 bg-[#F7F8FA] rounded-[3px] border border-[#D7DDE4] space-y-2.5">
                    <div class="flex items-center gap-2">
                        <span class="w-2.5 h-2.5 rounded-full bg-[#1769E0]"></span>
                        <strong class="text-xs font-bold text-[#202833] uppercase tracking-wider font-mono">Account-Enabled (Factory &amp; Supplier Portals)</strong>
                    </div>
                    <ul class="text-xs text-[#5F6B7A] space-y-1.5 pl-4 list-disc m-0">
                        <li>Issue formal multi-vendor Requests for Quote (RFQs) and compare incoming bids.</li>
                        <li>Supplier catalog inventory upload and stock level management.</li>
                        <li>Dispatch active emergency breakdown alerts to suppliers within geographic radius.</li>
                        <li>Schedule and track field service technician bookings directly to factory floor.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 5. Next Step Navigation -->
        <div class="p-6 bg-white border border-[#D7DDE4] rounded-[3px] flex flex-col sm:flex-row items-center justify-between gap-4 shadow-[0_2px_8px_-2px_rgba(20,35,55,0.04)]">
            <div class="text-left space-y-1">
                <h4 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Ready to explore the spare-parts catalog?</h4>
                <p class="text-xs text-[#667180] m-0">Search indexed components by OEM part number or browse regional supplier inventories.</p>
            </div>
            <div class="flex items-center gap-2 shrink-0">
                <a href="~/Public/Parts.aspx" runat="server" class="btn-primary text-xs py-2 px-4 font-bold">
                    Browse Parts Catalog →
                </a>
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2 px-4 font-bold">
                    Emergency Desk →
                </a>
            </div>
        </div>

    </div>
</asp:Content>

