<%@ Page Title="Why Us - Industrial Platform Differentiators" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="WhyUs.aspx.cs" Inherits="IndustrialSparePartPortal.Public.WhyUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Why manufacturing facilities choose SPAREFINDER for industrial spare-part discovery, multi-supplier comparison, and emergency breakdown procurement." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                Platform Capabilities &amp; Differentiators
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                Why Manufacturing Plants Choose SPAREFINDER
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                Eliminating fragmented vendor phone calls, uncertain inventory availability, and days of idle machine downtime through a structured digital sourcing network.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-10">
        
        <!-- 2. Traditional vs Platform Comparison Matrix -->
        <section class="space-y-4">
            <div class="space-y-1 text-left">
                <span class="text-xs font-mono font-bold text-[#1769E0] tracking-wider uppercase">Operational Benchmark</span>
                <h2 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#202833] m-0">
                    Traditional Offline Sourcing vs. SPAREFINDER Network
                </h2>
                <p class="text-xs sm:text-sm text-[#667180] m-0">How digital part indexing and multi-supplier visibility transform plant maintenance.</p>
            </div>

            <!-- Desktop Comparison Table (Hidden on small mobile) -->
            <div class="hidden md:block table-container shadow-xs">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th class="w-1/4">Procurement Vector</th>
                            <th class="w-3/8 text-[#964205] bg-[#FEF4EC]"><i class="fa-solid fa-xmark mr-1"></i> Traditional Offline Sourcing</th>
                            <th class="w-3/8 text-[#1769E0] bg-[#EAF2FF]"><i class="fa-solid fa-check mr-1"></i> SPAREFINDER Digital Platform</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-[#D7DDE4] text-xs">
                        <tr>
                            <td class="font-bold text-[#202833]">Part Identification</td>
                            <td class="text-[#667180]">Manual physical catalogs, vague verbal descriptions, high return rate</td>
                            <td class="text-[#202833] font-semibold"><i class="fa-solid fa-check text-[#16845B] mr-1.5"></i> OEM Part Number &amp; Machine Model cross-indexing</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#202833]">Supplier Discovery</td>
                            <td class="text-[#667180]">Limited to 2–3 known local dealers with opaque inventory</td>
                            <td class="text-[#202833] font-semibold"><i class="fa-solid fa-check text-[#16845B] mr-1.5"></i> Search across regional verified supplier inventory</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#202833]">Pricing Transparency</td>
                            <td class="text-[#667180]">Inconsistent quotes negotiated over disjointed phone calls</td>
                            <td class="text-[#202833] font-semibold"><i class="fa-solid fa-check text-[#16845B] mr-1.5"></i> Structured Request for Quote (RFQ) comparison matrix</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#202833]">Breakdown Escalation</td>
                            <td class="text-[#667180]">Days of idle downtime waiting for supplier callbacks</td>
                            <td class="text-[#202833] font-semibold"><i class="fa-solid fa-bolt text-[#F07818] mr-1.5"></i> Priority Emergency Breakdown broadcast alerts</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#202833]">Technical Commissioning</td>
                            <td class="text-[#667180]">Independent search for technicians with unverified skillsets</td>
                            <td class="text-[#202833] font-semibold"><i class="fa-solid fa-check text-[#16845B] mr-1.5"></i> Integrated field service technician network (PLC, CNC, Hydraulics)</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Mobile Comparison Cards (Shown on small screens) -->
            <div class="block md:hidden space-y-3">
                <div class="surface-card bg-white p-4 rounded-[3px] border border-[#D7DDE4] space-y-2 text-left">
                    <span class="font-bold text-[#202833] text-xs uppercase tracking-wider block font-mono">01 · Part Identification</span>
                    <div class="p-2.5 rounded-[2px] bg-[#FEF4EC] border border-[#FAD7BE] text-xs text-[#964205] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Manual catalogs, vague verbal descriptions, high return rate.</p>
                    </div>
                    <div class="p-2.5 rounded-[2px] bg-[#EAF2FF] border border-[#BFDBFE] text-xs text-[#0D4191] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">SPAREFINDER Network</span>
                        <p class="m-0 leading-snug font-medium">OEM Part Number &amp; Machine Model cross-indexing.</p>
                    </div>
                </div>

                <div class="surface-card bg-white p-4 rounded-[3px] border border-[#D7DDE4] space-y-2 text-left">
                    <span class="font-bold text-[#202833] text-xs uppercase tracking-wider block font-mono">02 · Supplier Discovery</span>
                    <div class="p-2.5 rounded-[2px] bg-[#FEF4EC] border border-[#FAD7BE] text-xs text-[#964205] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Limited to 2–3 local dealers with opaque, unverified shelf inventory.</p>
                    </div>
                    <div class="p-2.5 rounded-[2px] bg-[#EAF2FF] border border-[#BFDBFE] text-xs text-[#0D4191] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">SPAREFINDER Network</span>
                        <p class="m-0 leading-snug font-medium">Search verified regional supplier stock with distance metrics.</p>
                    </div>
                </div>

                <div class="surface-card bg-white p-4 rounded-[3px] border border-[#D7DDE4] space-y-2 text-left">
                    <span class="font-bold text-[#202833] text-xs uppercase tracking-wider block font-mono">03 · Breakdown Escalation</span>
                    <div class="p-2.5 rounded-[2px] bg-[#FEF4EC] border border-[#FAD7BE] text-xs text-[#964205] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">Traditional Offline</span>
                        <p class="m-0 leading-snug">Hours spent calling vendors while factory capacity remains idle.</p>
                    </div>
                    <div class="p-2.5 rounded-[2px] bg-[#EAF2FF] border border-[#BFDBFE] text-xs text-[#0D4191] space-y-0.5">
                        <span class="font-bold block text-[10px] uppercase">SPAREFINDER Network</span>
                        <p class="m-0 leading-snug font-medium">Instant priority broadcast alert across regional stockists.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 3. Tangible Technical Advantages -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5 text-left">
            
            <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] space-y-2">
                <div class="w-8 h-8 rounded-[2px] bg-[#EAF2FF] text-[#1769E0] flex items-center justify-center font-bold text-sm">
                    <i class="fa-solid fa-database"></i>
                </div>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Direct ADO.NET Architecture</h3>
                <p class="text-xs text-[#667180] leading-relaxed m-0">
                    Engineered with parameterized SQL Server queries for transparent execution, explicit SQL injection protection, and sub-millisecond query performance.
                </p>
            </div>

            <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] space-y-2">
                <div class="w-8 h-8 rounded-[2px] bg-[#E8F5F0] text-[#16845B] flex items-center justify-center font-bold text-sm">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">GSTIN Entity Auditing</h3>
                <p class="text-xs text-[#667180] leading-relaxed m-0">
                    Supplier and technician onboarding requires verified commercial documentation and trade credentials reviewed by platform administrators.
                </p>
            </div>

            <div class="surface-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] space-y-2">
                <div class="w-8 h-8 rounded-[2px] bg-[#FEF4EC] text-[#F07818] flex items-center justify-center font-bold text-sm">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Emergency Fast-Track</h3>
                <p class="text-xs text-[#667180] leading-relaxed m-0">
                    Dedicated emergency breakdown protocol alerts nearby stocking vendors and certified field technicians within a 2-hour response window.
                </p>
            </div>

        </div>

    </div>
</asp:Content>

