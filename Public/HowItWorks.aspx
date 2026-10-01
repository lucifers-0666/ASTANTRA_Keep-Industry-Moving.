<%@ Page Title="How It Works - Industrial Procurement Workflow" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HowItWorks.aspx.cs" Inherits="IndustrialSparePartPortal.Public.HowItWorks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Step-by-step industrial spare-part sourcing, supplier RFQ quotation, and emergency breakdown protocol workflow." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-blue font-mono text-xs">
                    <i class="fa-solid fa-route"></i> ARCHITECTURAL WORKFLOW SPECIFICATION
                </span>
                <span class="text-xs text-[#5F6B7A] font-mono">End-to-End Resolution Pipeline</span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                How Industrial Procurement Works
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                A structured digital workflow connecting plant maintenance departments, regional parts stockists, and on-site service engineers to eliminate machine downtime.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-10">
        
        <!-- 2. Visual Context Section -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-center">
            <div class="lg:col-span-5">
                <div class="rounded-[3px] overflow-hidden border border-[#D5DCE3] bg-white p-2">
                    <img src="<%= ResolveUrl("~/Content/images/warehouse_inventory_racks.jpg") %>" 
                         alt="Organized heavy industrial spare parts warehouse racks with parts bins" 
                         class="w-full h-[260px] sm:h-[300px] object-cover rounded-[2px]" 
                         loading="lazy" />
                </div>
            </div>
            <div class="lg:col-span-7 space-y-3 text-left">
                <span class="spec-tag spec-tag-blue font-mono text-xs">STANDARDIZED SOURCING PIPELINE</span>
                <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">
                    From Part Identification to Plant Commissioning
                </h2>
                <p class="text-xs sm:text-sm text-[#5F6B7A] leading-relaxed m-0">
                    Traditional procurement relies on unrecorded phone calls, imprecise descriptions, and uncertain warehouse stock. SPAREFINDER standardizes every stage through OEM catalog indexing, multi-vendor RFQ bidding, and verified technician assignment.
                </p>
                <div class="grid grid-cols-2 gap-3 pt-2 text-xs font-mono">
                    <div class="p-3 bg-white rounded-[3px] border border-[#D5DCE3]">
                        <span class="text-[#1769E0] font-bold block text-sm">&lt; 24 Hrs</span>
                        <span class="text-[#5F6B7A]">Standard RFQ Turnaround</span>
                    </div>
                    <div class="p-3 bg-white rounded-[3px] border border-[#D5DCE3]">
                        <span class="text-[#E87519] font-bold block text-sm">&lt; 2 Hrs</span>
                        <span class="text-[#5F6B7A]">Emergency Broadcast Target</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Three-Phase Structured Sourcing Sequence -->
        <div class="space-y-6">
            
            <!-- Phase 1: Technical Discovery -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#1769E0] uppercase tracking-wider font-mono">
                    <span class="w-5 h-5 rounded-[2px] bg-[#EBF2FD] text-[#1769E0] flex items-center justify-center text-[11px] font-bold">1</span>
                    <span>Phase 1 &middot; Catalog Discovery &amp; Specification Matching</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#1769E0] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#1769E0] block">STAGE 01</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Identify Requirement</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Plant engineer inspects failed equipment, recording OEM nameplate data and stamped component numbers (e.g. 6210-2RS).
                        </p>
                    </div>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#1769E0] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#1769E0] block">STAGE 02</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Search Indexed Catalog</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Buyer queries by part number or machine model, reviewing mechanical tolerances and compatible cross-references.
                        </p>
                    </div>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#1769E0] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#1769E0] block">STAGE 03</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Filter Regional Stockists</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Evaluate nearby suppliers on confirmed physical shelf inventory, transit distance, and compliance status.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Phase 2: Commercial Quotation -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#18865B] uppercase tracking-wider font-mono">
                    <span class="w-5 h-5 rounded-[2px] bg-[#E8F5F0] text-[#18865B] flex items-center justify-center text-[11px] font-bold">2</span>
                    <span>Phase 2 &middot; Commercial Quotation &amp; Order Authorization</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#18865B] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#18865B] block">STAGE 04</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Issue RFQ Bidding</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Submit digital RFQ with required quantity, delivery deadline, and plant site location to target vendors.
                        </p>
                    </div>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#18865B] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#18865B] block">STAGE 05</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Receive Itemized Bids</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Suppliers review shelf stock, calculate logistics freight, and submit firm price quotations with confirmed lead time.
                        </p>
                    </div>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#18865B] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#18865B] block">STAGE 06</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Approve Purchase Order</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Procurement selects the optimal quote balancing unit price and proximity, confirming dispatch priority.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Phase 3: Logistics & Commissioning -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#E87519] uppercase tracking-wider font-mono">
                    <span class="w-5 h-5 rounded-[2px] bg-[#FEF4EC] text-[#E87519] flex items-center justify-center text-[11px] font-bold">3</span>
                    <span>Phase 3 &middot; Logistics Dispatch &amp; Technician Commissioning</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#E87519] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#E87519] block">STAGE 07</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Priority Courier Dispatch</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Stockist packs OEM component with verified quality documentation, releasing same-day or next-morning dispatch.
                        </p>
                    </div>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#E87519] text-left space-y-2">
                        <span class="font-mono text-[11px] font-bold text-[#E87519] block">STAGE 08</span>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">On-Site Commissioning</h3>
                        <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                            Booked field technician arrives at the facility to align, install, and test the machinery before signing off.
                        </p>
                    </div>
                </div>
            </div>

        </div>

        <!-- 4. Next Step Navigation -->
        <div class="p-6 bg-white border border-[#D5DCE3] rounded-[3px] flex flex-col sm:flex-row items-center justify-between gap-4">
            <div class="text-left space-y-1">
                <h4 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Ready to test the procurement workflow?</h4>
                <p class="text-xs text-[#5F6B7A] m-0">Query the indexed catalog by part number or browse regional supplier stock.</p>
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

