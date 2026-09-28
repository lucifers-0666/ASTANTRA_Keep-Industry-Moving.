<%@ Page Title="Why Us - Industrial Platform Differentiators" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="WhyUs.aspx.cs" Inherits="IndustrialSparePartPortal.Public.WhyUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Why manufacturing facilities choose SPAREFINDER for industrial spare-part discovery, multi-supplier comparison, and emergency breakdown procurement." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. HEADER BANNER                                                             -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">
                Platform Value Proposition
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                Why Manufacturing Plants Choose SPAREFINDER
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                Replacing fragmented phone calls, opaque inventory, and prolonged equipment downtime with structured digital procurement.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-12">
        
        <!-- ============================================================================ -->
        <!-- 2. FOUR PRACTICAL REASONS                                                    -->
        <!-- 4 clear, concrete engineering reasons                                         -->
        <!-- ============================================================================ -->
        <section class="space-y-4">
            <div class="text-left space-y-1">
                <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">Core Advantages</span>
                <h2 class="text-xl font-bold text-[#111827] m-0">Engineered for Industrial Reliability</h2>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
                
                <!-- Reason 1 -->
                <div class="surface-card p-5 space-y-2.5 text-left">
                    <div class="w-9 h-9 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm font-bold">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Verified Suppliers</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Audited regional stockists with confirmed physical warehouse inventory to guarantee genuine OEM tolerances.
                    </p>
                </div>

                <!-- Reason 2 -->
                <div class="surface-card p-5 space-y-2.5 text-left">
                    <div class="w-9 h-9 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm font-bold">
                        <i class="fa-solid fa-code-compare"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Transparent Comparison</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Compare itemized quotation pricing, confirmed shelf stock availability, and transit lead times side-by-side.
                    </p>
                </div>

                <!-- Reason 3 -->
                <div class="surface-card p-5 space-y-2.5 text-left">
                    <div class="w-9 h-9 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm font-bold">
                        <i class="fa-solid fa-bolt"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Faster Procurement</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Direct digital inquiries eliminate multi-tier middleman delays and lengthy vendor phone callbacks.
                    </p>
                </div>

                <!-- Reason 4 -->
                <div class="surface-card p-5 space-y-2.5 text-left">
                    <div class="w-9 h-9 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm font-bold">
                        <i class="fa-solid fa-user-gear"></i>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Technical Support</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Integrated access to certified on-call field engineers for machine diagnostics, precision fitting, and alignment.
                    </p>
                </div>

            </div>
        </section>

        <!-- ============================================================================ -->
        <!-- 3. TRADITIONAL VS PLATFORM COMPARISON MATRIX                                 -->
        <!-- Professional, high-contrast B2B comparison table                             -->
        <!-- ============================================================================ -->
        <section class="space-y-4">
            <div class="text-left space-y-1">
                <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">Operational Shift</span>
                <h2 class="text-xl font-bold text-[#111827] m-0">Traditional Sourcing vs. SPAREFINDER</h2>
            </div>

            <div class="table-container">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th class="w-1/4">Procurement Parameter</th>
                            <th class="w-3/8 text-slate-700">Traditional Offline Sourcing</th>
                            <th class="w-3/8 text-[#1769E0]">SPAREFINDER Platform</th>
                        </tr>
                    </thead>
                    <tbody class="text-xs">
                        <tr>
                            <td class="font-bold text-[#111827]">Part Identification</td>
                            <td class="text-[#5F6B7A]">Vague verbal descriptions, high return rate</td>
                            <td class="text-[#111827] font-semibold"><i class="fa-solid fa-check text-[#18865B] mr-1.5"></i> OEM part # &amp; machine model cross-indexing</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#111827]">Supplier Discovery</td>
                            <td class="text-[#5F6B7A]">Limited to 2–3 local dealers with unknown stock</td>
                            <td class="text-[#111827] font-semibold"><i class="fa-solid fa-check text-[#18865B] mr-1.5"></i> Verified regional supplier directory with stock status</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#111827]">Pricing &amp; RFQs</td>
                            <td class="text-[#5F6B7A]">Inconsistent verbal quotes over phone calls</td>
                            <td class="text-[#111827] font-semibold"><i class="fa-solid fa-check text-[#18865B] mr-1.5"></i> Itemized quotation matrix with delivery timeframes</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#111827]">Machine Breakdown</td>
                            <td class="text-[#5F6B7A]">Days of idle plant capacity waiting for responses</td>
                            <td class="text-[#111827] font-semibold"><i class="fa-solid fa-bolt text-[#E87519] mr-1.5"></i> Emergency broadcast protocol with &lt; 2 hr target</td>
                        </tr>
                        <tr>
                            <td class="font-bold text-[#111827]">Installation Support</td>
                            <td class="text-[#5F6B7A]">Independent search for uncertified mechanics</td>
                            <td class="text-[#111827] font-semibold"><i class="fa-solid fa-check text-[#18865B] mr-1.5"></i> Certified field engineers (PLC, Hydraulics, Fitting)</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- ============================================================================ -->
        <!-- 4. COMPACT FINAL CTA                                                         -->
        <!-- ============================================================================ -->
        <section class="surface-card p-6 sm:p-8 flex flex-col md:flex-row items-start md:items-center justify-between gap-6 text-left">
            <div class="space-y-1 max-w-xl">
                <h3 class="text-lg font-bold text-[#111827] m-0">Ready to Streamline Your Plant Procurement?</h3>
                <p class="text-xs sm:text-sm text-[#5F6B7A] m-0 leading-relaxed">
                    Create your Factory account to access indexed catalogs, broadcast emergency requests, and compare supplier quotes.
                </p>
            </div>
            <div class="flex items-center gap-3 shrink-0">
                <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2.5 px-5">
                    Register Entity
                </a>
                <a href="~/Account/Login.aspx" runat="server" class="btn-secondary text-xs py-2.5 px-5">
                    Sign In
                </a>
            </div>
        </section>

    </div>
</asp:Content>

