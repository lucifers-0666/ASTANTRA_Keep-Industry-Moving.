<%@ Page Title="Why Us - Industrial Platform Differentiators" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="WhyUs.aspx.cs" Inherits="IndustrialSparePartPortal.Public.WhyUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Why manufacturing facilities choose SPAREFINDER for industrial spare-part discovery, multi-supplier comparison, and emergency breakdown procurement." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-blue">
                    <i class="fa-solid fa-code-compare"></i> PLATFORM VALUE PROPOSITION
                </span>
                <span class="spec-tag spec-tag-amber">
                    ARCHITECTURAL ADVANTAGES
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                Why Manufacturing Plants Choose SPAREFINDER
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                Eliminating fragmented phone calls, uncertain inventory availability, and days of idle machine downtime through a structured digital sourcing network.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-16">
        
        <!-- 2. Traditional vs Platform Comparison Table -->
        <section class="space-y-6">
            <div class="space-y-1 text-left">
                <span class="spec-tag spec-tag-blue">OPERATIONAL COMPARISON</span>
                <h2 class="text-xl sm:text-2xl font-bold text-[#0F172A] m-0">Traditional Sourcing vs. SPAREFINDER Platform</h2>
                <p class="text-xs sm:text-sm text-[#475569] m-0">How digital part indexing and multi-supplier visibility transform plant maintenance.</p>
            </div>

            <!-- Desktop Comparison Table (Hidden on small mobile) -->
            <div class="hidden md:block table-container shadow-xs">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th class="w-1/4">Procurement Parameter</th>
                            <th class="w-3/8 text-red-700 bg-red-50/60"><i class="fa-solid fa-xmark mr-1"></i> Traditional Offline Sourcing</th>
                            <th class="w-3/8 text-[#1D4ED8] bg-blue-50/60"><i class="fa-solid fa-check mr-1"></i> SPAREFINDER Platform Architecture</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-[#E2E8F0] text-xs">
                        <tr>
                            <td class="font-bold text-[#0F172A]">Part Identification</td>
                            <td class="text-[#475569]">Manual physical catalogs, vague verbal descriptions, high return rate</td>
                            <td class="text-[#0F172A] font-semibold"><i class="fa-solid fa-check text-emerald-600 mr-1.5"></i> OEM Part Number &amp; Machine Model cross-indexing</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#0F172A]">Supplier Discovery</td>
                            <td class="text-[#475569]">Limited to 2–3 known local dealers with opaque inventory</td>
                            <td class="text-[#0F172A] font-semibold"><i class="fa-solid fa-check text-emerald-600 mr-1.5"></i> Search across verified regional supplier inventory</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#0F172A]">Pricing Transparency</td>
                            <td class="text-[#475569]">Inconsistent quotes negotiated over disjointed phone calls</td>
                            <td class="text-[#0F172A] font-semibold"><i class="fa-solid fa-check text-emerald-600 mr-1.5"></i> Structured Request for Quote (RFQ) comparison matrix</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#0F172A]">Breakdown Response</td>
                            <td class="text-[#475569]">Days of machine downtime waiting for supplier callbacks</td>
                            <td class="text-[#0F172A] font-semibold"><i class="fa-solid fa-bolt text-[#EA580C] mr-1.5"></i> High-priority Emergency Breakdown broadcast alerts (Planned workflow)</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#0F172A]">Technical Installation</td>
                            <td class="text-[#475569]">Independent search for technicians with unverified skillsets</td>
                            <td class="text-[#0F172A] font-semibold"><i class="fa-solid fa-check text-emerald-600 mr-1.5"></i> Integrated field service technician network (PLC, CNC, Hydraulics)</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Mobile Comparison Cards (Shown on small screens) -->
            <div class="block md:hidden space-y-4">
                <div class="surface-card p-4 space-y-3 text-left">
                    <span class="font-bold text-[#0F172A] text-xs uppercase tracking-wider block font-mono">01 · Part Identification</span>
                    <div class="p-2.5 rounded-lg bg-red-50/70 border border-red-200 text-xs text-red-900 space-y-0.5">
                        <span class="font-bold block text-[10px] text-red-600 uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Manual catalogs, vague verbal descriptions, high shipping return rate.</p>
                    </div>
                    <div class="p-2.5 rounded-lg bg-blue-50/70 border border-blue-200 text-xs text-blue-950 space-y-0.5">
                        <span class="font-bold block text-[10px] text-[#1D4ED8] uppercase">SPAREFINDER Platform</span>
                        <p class="m-0 leading-snug font-medium">OEM Part Number &amp; Machine Model cross-indexing index.</p>
                    </div>
                </div>

                <div class="surface-card p-4 space-y-3 text-left">
                    <span class="font-bold text-[#0F172A] text-xs uppercase tracking-wider block font-mono">02 · Supplier Discovery</span>
                    <div class="p-2.5 rounded-lg bg-red-50/70 border border-red-200 text-xs text-red-900 space-y-0.5">
                        <span class="font-bold block text-[10px] text-red-600 uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Limited to 2–3 local dealers with opaque, unverified shelf inventory.</p>
                    </div>
                    <div class="p-2.5 rounded-lg bg-blue-50/70 border border-blue-200 text-xs text-blue-950 space-y-0.5">
                        <span class="font-bold block text-[10px] text-[#1D4ED8] uppercase">SPAREFINDER Platform</span>
                        <p class="m-0 leading-snug font-medium">Search across regional registered stockists with stock status.</p>
                    </div>
                </div>

                <div class="surface-card p-4 space-y-3 text-left">
                    <span class="font-bold text-[#0F172A] text-xs uppercase tracking-wider block font-mono">03 · Pricing Transparency</span>
                    <div class="p-2.5 rounded-lg bg-red-50/70 border border-red-200 text-xs text-red-900 space-y-0.5">
                        <span class="font-bold block text-[10px] text-red-600 uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Inconsistent quotes negotiated over disjointed individual calls.</p>
                    </div>
                    <div class="p-2.5 rounded-lg bg-blue-50/70 border border-blue-200 text-xs text-blue-950 space-y-0.5">
                        <span class="font-bold block text-[10px] text-[#1D4ED8] uppercase">SPAREFINDER Platform</span>
                        <p class="m-0 leading-snug font-medium">Structured Request for Quote (RFQ) comparison matrix.</p>
                    </div>
                </div>

                <div class="surface-card p-4 space-y-3 text-left">
                    <span class="font-bold text-[#0F172A] text-xs uppercase tracking-wider block font-mono">04 · Breakdown Response</span>
                    <div class="p-2.5 rounded-lg bg-red-50/70 border border-red-200 text-xs text-red-900 space-y-0.5">
                        <span class="font-bold block text-[10px] text-red-600 uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Days of machine downtime waiting for supplier callbacks.</p>
                    </div>
                    <div class="p-2.5 rounded-lg bg-blue-50/70 border border-blue-200 text-xs text-blue-950 space-y-0.5">
                        <span class="font-bold block text-[10px] text-[#1D4ED8] uppercase">SPAREFINDER Platform</span>
                        <p class="m-0 leading-snug font-medium">High-priority Emergency Breakdown broadcast alerts.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 3. Core Architectural Differentiators -->
        <section class="space-y-6">
            <div class="space-y-1 text-left">
                <span class="spec-tag spec-tag-blue">CORE ADVANTAGES</span>
                <h2 class="text-xl sm:text-2xl font-bold text-[#0F172A] m-0">Engineered Specifically for Industrial Plants</h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 text-left">
                
                <div class="surface-card p-6 space-y-3">
                    <div class="w-10 h-10 rounded-lg bg-blue-50 text-[#1D4ED8] flex items-center justify-center font-bold text-base border border-blue-200">
                        <i class="fa-solid fa-barcode"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">Exact OEM Part Matching</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Cross-index by stamped OEM part numbers or machine model (CNC lathe, hydraulic press, air compressor) to prevent expensive incorrect order shipments.
                    </p>
                </div>

                <div class="surface-card p-6 space-y-3">
                    <div class="w-10 h-10 rounded-lg bg-emerald-50 text-[#059669] flex items-center justify-center font-bold text-base border border-emerald-200">
                        <i class="fa-solid fa-warehouse"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">Verified Stock Visibility</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Know whether a supplier has ready physical shelf inventory or requires a 3-week manufacturer lead time before committing to purchase orders.
                    </p>
                </div>

                <div class="surface-card p-6 space-y-3">
                    <div class="w-10 h-10 rounded-lg bg-orange-50 text-[#EA580C] flex items-center justify-center font-bold text-base border border-orange-200">
                        <i class="fa-solid fa-user-gear"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">Connected Technical Labor</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Pair your spare-part procurement directly with certified regional maintenance engineers ready to perform precision fitting, alignment, and commissioning.
                    </p>
                </div>

            </div>
        </section>

        <!-- 4. Governance & Verification Notice -->
        <section class="surface-card p-6 sm:p-8 space-y-4" id="verification">
            <div class="flex items-center gap-2">
                <span class="spec-tag spec-tag-emerald"><i class="fa-solid fa-shield-halved"></i> COMPLIANCE &amp; GOVERNANCE</span>
            </div>
            <h2 class="text-xl font-bold text-[#0F172A] m-0">Entity Verification &amp; Account Governance</h2>
            <p class="text-xs sm:text-sm text-[#475569] m-0 leading-relaxed max-w-3xl">
                To maintain commercial credibility, supplier profiles are verified against government GSTIN registrations, business operating licenses, and authorized distributor agreements prior to platform activation.
            </p>
            <div class="p-4 bg-amber-50/70 border border-amber-200 rounded-xl text-xs text-amber-900 leading-relaxed font-mono">
                <strong>MCA Academic Project Defense Note:</strong> In this evaluation instance, vendor directories feature curated demonstration profiles to showcase comparison mechanics, ADO.NET query execution, and role-based access control.
            </div>
        </section>

    </div>
</asp:Content>

