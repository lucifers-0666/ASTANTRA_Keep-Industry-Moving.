<%@ Page Title="How It Works - Industrial Procurement Workflow" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HowItWorks.aspx.cs" Inherits="IndustrialSparePartPortal.Public.HowItWorks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Step-by-step industrial spare-part sourcing, supplier RFQ quotation, and emergency breakdown protocol workflow." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-blue">
                    <i class="fa-solid fa-route"></i> ARCHITECTURAL WORKFLOW SPECIFICATION
                </span>
                <span class="spec-tag spec-tag-emerald">
                    END-TO-END PROCUREMENT LIFECYCLE
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                How Industrial Procurement Works
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                A structured digital workflow connecting plant maintenance departments, regional parts stockists, and on-site service engineers to eliminate machine downtime.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-16">
        
        <!-- 2. Visual Stage Introduction with Real Warehouse Photography -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            <div class="lg:col-span-5">
                <div class="rounded-2xl overflow-hidden border border-[#CBD5E1] shadow-md group">
                    <img src="<%= ResolveUrl("~/Content/images/warehouse_inventory_racks.jpg") %>" 
                         alt="Organized heavy industrial spare parts warehouse racks with parts bins" 
                         class="w-full h-[280px] sm:h-[320px] object-cover group-hover:scale-105 transition-transform duration-700" 
                         loading="lazy" />
                </div>
            </div>
            <div class="lg:col-span-7 space-y-4 text-left">
                <span class="spec-tag spec-tag-blue">ZERO-AMBIGUITY SOURCING</span>
                <h2 class="text-xl sm:text-2xl font-bold text-[#0F172A] m-0">From Part Identification to Plant Installation</h2>
                <p class="text-xs sm:text-sm text-[#475569] leading-relaxed m-0">
                    Traditional procurement relies on unrecorded phone calls, imprecise descriptions, and uncertain warehouse stock. SPAREFINDER standardizes every stage through OEM catalog indexing, multi-vendor RFQ bidding, and verified technician assignment.
                </p>
                <div class="grid grid-cols-2 gap-4 pt-2 text-xs font-mono">
                    <div class="p-3 bg-[#F8FAFC] rounded-lg border border-[#E2E8F0]">
                        <span class="text-[#1D4ED8] font-bold block text-sm">&lt; 24 Hrs</span>
                        <span class="text-[#64748B]">Standard RFQ Turnaround</span>
                    </div>
                    <div class="p-3 bg-[#F8FAFC] rounded-lg border border-[#E2E8F0]">
                        <span class="text-[#EA580C] font-bold block text-sm">&lt; 2 Hrs</span>
                        <span class="text-[#64748B]">Emergency Broadcast Target</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Standard 8-Step Sourcing Workflow (Grouped into 3 Architectural Phases) -->
        <section class="space-y-8">
            <div class="space-y-1 text-left">
                <div class="flex items-center gap-2">
                    <span class="spec-tag spec-tag-blue">8-STAGE LIFECYCLE</span>
                    <span class="text-xs text-[#64748B] font-mono">PLANNED B2B ARCHITECTURE</span>
                </div>
                <h2 class="text-xl sm:text-2xl font-bold text-[#0F172A] m-0">Standard Sourcing &amp; Procurement Sequence</h2>
                <p class="text-xs sm:text-sm text-[#475569] m-0">The workflow model conceptualized for the SPAREFINDER procurement ecosystem.</p>
            </div>

            <!-- Phase 1: Technical Discovery (Stages 1-3) -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#1D4ED8] uppercase tracking-wider font-mono">
                    <span class="w-6 h-6 rounded-full bg-blue-100 text-[#1D4ED8] flex items-center justify-center text-xs">A</span>
                    <span>Phase 1 · Identification &amp; Directory Discovery</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#1D4ED8] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#1D4ED8] block">STAGE 01</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Identify Requirement</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Plant engineer inspects failed equipment, recording OEM nameplate data and stamped component numbers (e.g. 6210-2RS).
                        </p>
                    </div>
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#1D4ED8] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#1D4ED8] block">STAGE 02</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Search Indexed Catalog</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Buyer searches the platform by part number or machine model, reviewing mechanical tolerances and compatible cross-references.
                        </p>
                    </div>
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#1D4ED8] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#1D4ED8] block">STAGE 03</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Compare Regional Stockists</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Evaluate regional suppliers on confirmed shelf inventory, transit distance, verified compliance, and historical rating.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Phase 2: Commercial Quotation (Stages 4-6) -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#059669] uppercase tracking-wider font-mono">
                    <span class="w-6 h-6 rounded-full bg-emerald-100 text-[#059669] flex items-center justify-center text-xs">B</span>
                    <span>Phase 2 · RFQ Quotation &amp; Commercial Award</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#059669] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#059669] block">STAGE 04</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Submit Structured RFQ</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Issue a formal Request for Quotation specifying required quantity, delivery deadline, and plant receiving location.
                        </p>
                    </div>
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#059669] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#059669] block">STAGE 05</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Supplier Quotation</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Stockists submit itemized price quotes detailing unit pricing, freight charges, and estimated dispatch windows.
                        </p>
                    </div>
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#059669] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#059669] block">STAGE 06</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Quote Selection &amp; PO</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Factory buyer compares bids side-by-side, selects optimal commercial terms, and confirms procurement order.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Phase 3: Logistics & Commissioning (Stages 7-8) -->
            <div class="space-y-3">
                <div class="flex items-center gap-2 text-xs font-bold text-[#EA580C] uppercase tracking-wider font-mono">
                    <span class="w-6 h-6 rounded-full bg-orange-100 text-[#EA580C] flex items-center justify-center text-xs">C</span>
                    <span>Phase 3 · Dispatch Logistics &amp; On-Site Fitting</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#EA580C] block">STAGE 07</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Dispatch &amp; Technician Mobilize</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Supplier dispatches part via designated carrier. Simultaneously, an on-call field technician is scheduled for arrival.
                        </p>
                    </div>
                    <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C] text-left">
                        <span class="font-mono text-[11px] font-bold text-[#EA580C] block">STAGE 08</span>
                        <h3 class="text-sm font-bold text-[#0F172A] m-0">Installation &amp; Sign-Off</h3>
                        <p class="text-xs text-[#475569] leading-relaxed m-0">
                            Component is physically inspected, fitted to machine, test-run verified, and delivery confirmed in portal workspace.
                        </p>
                    </div>
                </div>
            </div>

        </section>

        <!-- 4. Emergency Breakdown Fast-Track vs Standard Sourcing -->
        <section class="surface-card p-6 sm:p-8 space-y-6" id="protocol">
            <div class="flex items-center gap-2">
                <span class="spec-tag spec-tag-orange">EMERGENCY PROTOCOL</span>
                <span class="text-xs text-[#64748B] font-mono">CRITICAL BREAKDOWN BYPASS</span>
            </div>
            <h2 class="text-xl font-bold text-[#0F172A] m-0">How the Emergency Protocol Bypasses Standard RFQ Delays</h2>
            <p class="text-xs sm:text-sm text-[#475569] m-0 leading-relaxed max-w-3xl">
                When a critical machine fails, standard 24-hour RFQ windows cannot be tolerated. The Emergency Protocol broadcasts simultaneously to all regional verified suppliers possessing category stock, alerting on-call coordinators within minutes.
            </p>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
                <div class="p-4 bg-slate-50 rounded-xl border border-[#CBD5E1] space-y-2">
                    <span class="font-bold text-[#0F172A] block text-sm font-sans">Standard Sourcing:</span>
                    <div>&bull; Multi-day vendor inquiries</div>
                    <div>&bull; 24-48 hr quotation turnaround</div>
                    <div>&bull; Scheduled batch shipping</div>
                </div>
                <div class="p-4 bg-orange-50/70 rounded-xl border border-orange-200 space-y-2">
                    <span class="font-bold text-[#EA580C] block text-sm font-sans">Emergency Protocol:</span>
                    <div>&bull; Instant proximity broadcast alert</div>
                    <div>&bull; &lt; 2 hour direct quote &amp; pickup confirmation</div>
                    <div>&bull; Same-day expedited dedicated transit</div>
                </div>
            </div>
        </section>

    </div>
</asp:Content>

