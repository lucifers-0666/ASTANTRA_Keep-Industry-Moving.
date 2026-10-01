<%@ Page Title="How It Works - Industrial Procurement Workflow" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HowItWorks.aspx.cs" Inherits="IndustrialSparePartPortal.Public.HowItWorks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Step-by-step industrial spare-part sourcing, supplier RFQ quotation, and emergency breakdown protocol workflow." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. HERO BANNER                                                               -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">
                Workflow Specification
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                How SPAREFINDER Works
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                A structured digital workflow connecting plant maintenance departments, regional parts stockists, and on-site service engineers to eliminate machine downtime.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-10">
        
        <!-- ============================================================================ -->
        <!-- 2. CORE 3-STEP PROCUREMENT WORKFLOW                                          -->
        <!-- ============================================================================ -->
        <section class="space-y-4">
            <div class="text-left space-y-1">
                <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">Standard Procurement Sequence</span>
                <h2 class="text-xl font-bold text-[#111827] m-0">Three Steps from Part Inquiry to Delivery</h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                
                <!-- Step 1 -->
                <div class="surface-card p-6 space-y-3 text-left">
                    <div class="flex items-center justify-between">
                        <span class="text-xs font-mono font-bold text-[#1769E0]">STEP 01</span>
                        <div class="w-8 h-8 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </div>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Find the Part</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Search indexed components by stamped OEM part number (e.g. 6210-2RS) or compatible machine model to review exact technical tolerances.
                    </p>
                </div>

                <!-- Step 2 -->
                <div class="surface-card p-6 space-y-3 text-left">
                    <div class="flex items-center justify-between">
                        <span class="text-xs font-mono font-bold text-[#1769E0]">STEP 02</span>
                        <div class="w-8 h-8 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-code-compare"></i>
                        </div>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Compare Suppliers</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Evaluate regional stockists side-by-side on confirmed shelf inventory, transit distance, and itemized quotation pricing.
                    </p>
                </div>

                <!-- Step 3 -->
                <div class="surface-card p-6 space-y-3 text-left">
                    <div class="flex items-center justify-between">
                        <span class="text-xs font-mono font-bold text-[#1769E0]">STEP 03</span>
                        <div class="w-8 h-8 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center font-bold text-sm">
                            <i class="fa-solid fa-truck-fast"></i>
                        </div>
                    </div>
                    <h3 class="text-base font-bold text-[#111827] m-0">Procure the Part</h3>
                    <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                        Confirm purchase orders, coordinate dedicated freight dispatch, and mobilize certified on-call field technicians if installation is required.
                    </p>
                </div>

            </div>
        </section>

        <!-- ============================================================================ -->
        <!-- 3. EMERGENCY FAST-TRACK PROTOCOL                                             -->
        <!-- ============================================================================ -->
        <section class="surface-card p-6 sm:p-8 space-y-5 text-left border-l-4 border-l-[#E87519]">
            <div class="space-y-1">
                <span class="text-xs font-mono font-bold text-[#E87519] uppercase tracking-wider block">
                    Breakdown Fast-Track Protocol
                </span>
                <h2 class="text-xl font-bold text-[#111827] m-0">
                    When Machine Breakdown Occurs
                </h2>
                <p class="text-xs sm:text-sm text-[#5F6B7A] m-0 leading-relaxed max-w-2xl">
                    Critical equipment stoppage requires immediate escalation. The Emergency Protocol bypasses multi-day procurement cycles through instant regional broadcasts.
                </p>
            </div>

            <!-- 4-Stage Horizontal Flow -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-2">
                <div class="p-4 rounded bg-[#F8F9FA] border border-[#E5E9EE] space-y-1.5">
                    <span class="text-[11px] font-mono font-bold text-[#E87519] block">STAGE 1</span>
                    <strong class="text-xs font-bold text-[#111827] block">Machine Breakdown</strong>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-snug">Plant floor logs failed equipment and observed failure symptoms.</p>
                </div>

                <div class="p-4 rounded bg-[#F8F9FA] border border-[#E5E9EE] space-y-1.5">
                    <span class="text-[11px] font-mono font-bold text-[#E87519] block">STAGE 2</span>
                    <strong class="text-xs font-bold text-[#111827] block">Emergency Request</strong>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-snug">Priority alert broadcast with OEM part numbers and urgency severity.</p>
                </div>

                <div class="p-4 rounded bg-[#F8F9FA] border border-[#E5E9EE] space-y-1.5">
                    <span class="text-[11px] font-mono font-bold text-[#E87519] block">STAGE 3</span>
                    <strong class="text-xs font-bold text-[#111827] block">Vendor &amp; Tech Response</strong>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-snug">Regional stockists confirm ready stock; nearby technician is alerted.</p>
                </div>

                <div class="p-4 rounded bg-[#F8F9FA] border border-[#E5E9EE] space-y-1.5">
                    <span class="text-[11px] font-mono font-bold text-[#E87519] block">STAGE 4</span>
                    <strong class="text-xs font-bold text-[#111827] block">Rapid Resolution</strong>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-snug">Same-day transit and on-site fitting return the assembly line to operation.</p>
                </div>
            </div>

            <div class="pt-2 flex items-center justify-between border-t border-[#D9DEE5]">
                <span class="text-xs text-[#5F6B7A] font-mono">Response Target: &lt; 2 Hours for critical emergencies</span>
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2 px-4">
                    Open Emergency Desk →
                </a>
            </div>
        </section>

    </div>
</asp:Content>

