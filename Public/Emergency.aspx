<%@ Page Title="Emergency Breakdown Sourcing Desk" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Emergency.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Emergency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Submit high-priority emergency spare-part breakdown requests to broadcast to regional suppliers and mobilize on-call field technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-orange">
                    <i class="fa-solid fa-triangle-exclamation"></i> HIGH-PRIORITY PROCUREMENT DESK
                </span>
                <span class="spec-tag spec-tag-amber">
                    BREAKDOWN RESPONSE TIME: &lt; 2 HOURS
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                Emergency Breakdown Sourcing Desk
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                When an assembly line halts, every minute of idle capacity costs thousands. Broadcast critical component requests across nearby verified stockists and alert on-call field engineers.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-12">
        
        <!-- 2. Fast-Track Protocol Sequence (4 Steps) -->
        <section class="space-y-4">
            <div class="space-y-1 text-left">
                <span class="spec-tag spec-tag-blue">RAPID ESCALATION WORKFLOW</span>
                <h2 class="text-xl font-bold text-[#0F172A] m-0">How Emergency Breakdown Sourcing Operates</h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C]">
                    <span class="font-mono text-xs font-bold text-[#EA580C]">STEP 01</span>
                    <h3 class="text-sm font-bold text-[#0F172A] m-0">1. Log Breakdown</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Submit machine model, stamped OEM part numbers, and observed failure symptoms with critical urgency level.
                    </p>
                </div>

                <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C]">
                    <span class="font-mono text-xs font-bold text-[#EA580C]">STEP 02</span>
                    <h3 class="text-sm font-bold text-[#0F172A] m-0">2. Supplier Broadcast</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Platform immediately alerts regional stockists within proximity possessing matching category inventory.
                    </p>
                </div>

                <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C]">
                    <span class="font-mono text-xs font-bold text-[#EA580C]">STEP 03</span>
                    <h3 class="text-sm font-bold text-[#0F172A] m-0">3. Rapid Quotation</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Suppliers confirm ready shelf stock, expedited pickup availability, or same-day courier dispatch charges.
                    </p>
                </div>

                <div class="surface-card p-5 space-y-2 border-l-4 border-l-[#EA580C]">
                    <span class="font-mono text-xs font-bold text-[#EA580C]">STEP 04</span>
                    <h3 class="text-sm font-bold text-[#0F172A] m-0">4. Priority Fitting</h3>
                    <p class="text-xs text-[#475569] leading-relaxed m-0">
                        Part is expedited to the plant while on-call field technicians are alerted for immediate on-site replacement.
                    </p>
                </div>
            </div>
        </section>

        <!-- 3. Form & Checklist Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- Left: Interactive Emergency Sourcing Form -->
            <div class="lg:col-span-7 surface-card p-6 sm:p-8 space-y-5 border-2 border-orange-200">
                <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-4">
                    <div class="flex items-center gap-2.5">
                        <div class="w-8 h-8 rounded-lg bg-[#EA580C] text-white flex items-center justify-center text-sm font-bold">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <div>
                            <h3 class="text-base font-bold text-[#0F172A] m-0">Broadcast Emergency Request</h3>
                            <span class="text-xs text-[#64748B] font-mono">HIGH-PRIORITY SUPPLIER NOTIFICATION</span>
                        </div>
                    </div>
                    <span class="spec-tag spec-tag-orange">CRITICAL DESK</span>
                </div>

                <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="p-4 rounded-xl bg-blue-50 border border-blue-200 text-xs text-[#0F172A] space-y-1">
                    <strong class="font-bold block text-[#1D4ED8]"><i class="fa-solid fa-circle-info mr-1"></i> Sign In Required to Broadcast</strong>
                    <span>Your emergency request details are saved. Please sign in with your Factory account to dispatch the broadcast.</span>
                </asp:Panel>

                <div class="space-y-4 text-xs">
                    <div>
                        <label class="form-label" for="<%= txtMachineName.ClientID %>">Equipment / Machine Name <span class="text-red-500">*</span></label>
                        <asp:TextBox ID="txtMachineName" runat="server" CssClass="form-input" Placeholder="e.g. CNC Lathe X200, 500T Hydraulic Press, Air Compressor 75HP"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= txtPartNumber.ClientID %>">OEM Part # or Spec <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-input font-mono" Placeholder="e.g. 6210-2RS, PART-HYD-001"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtQuantity.ClientID %>">Required Quantity <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" CssClass="form-input font-mono"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= ddlUrgency.ClientID %>">Urgency Severity Level</label>
                            <asp:DropDownList ID="ddlUrgency" runat="server" CssClass="form-input font-medium">
                                <asp:ListItem Value="Critical" Text="CRITICAL - Assembly Line Stopped"></asp:ListItem>
                                <asp:ListItem Value="Urgent" Text="URGENT - Failure Expected Within 24 Hrs"></asp:ListItem>
                                <asp:ListItem Value="Priority" Text="PRIORITY - Zero Safety Buffer Stock"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtCity.ClientID %>">Plant Location / City <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-input" Placeholder="e.g. Pune MIDC, Sanand GIDC, Ahmedabad"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="form-label" for="<%= txtDescription.ClientID %>">Breakdown Description / Failure Symptoms</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-input font-mono text-xs" Placeholder="Describe observed symptoms (e.g. pressure dropped below 50 bar, servo drive alarm code 0x4F, bearing overheating and seizing)..."></asp:TextBox>
                    </div>

                    <div class="pt-2">
                        <asp:Button ID="btnSubmitEmergency" runat="server" Text="Dispatch Emergency Broadcast →" OnClick="btnSubmitEmergency_Click" CssClass="btn-emergency w-full justify-center text-xs py-3 font-bold cursor-pointer" />
                    </div>

                    <p class="text-[11px] text-[#64748B] text-center m-0 font-mono">
                        <i class="fa-solid fa-lock mr-1"></i> Requires authenticated Factory account. Unregistered users are redirected to login.
                    </p>
                </div>
            </div>

            <!-- Right: Breakdown Triage Checklist & Helpline -->
            <div class="lg:col-span-5 space-y-6">
                
                <!-- Triage Checklist -->
                <div class="surface-card p-6 space-y-4">
                    <div class="flex items-center gap-2">
                        <span class="spec-tag spec-tag-blue"><i class="fa-solid fa-clipboard-check"></i> PRE-DISPATCH CHECKLIST</span>
                    </div>
                    <h3 class="text-base font-bold text-[#0F172A] m-0">Plant Breakdown Triage Checklist</h3>
                    <p class="text-xs text-[#475569] m-0 leading-relaxed">
                        Gather these specifications to ensure suppliers dispatch exact replacement tolerances:
                    </p>

                    <div class="space-y-3 text-xs text-[#334155]">
                        <div class="p-3 bg-[#F8FAFC] rounded-lg border border-[#E2E8F0] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-emerald-600 mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#0F172A] block font-bold">OEM Nameplate Verification:</strong>
                                Check motor/pump rating plate for serial number, voltage, flow rate, and pressure.
                            </div>
                        </div>
                        <div class="p-3 bg-[#F8FAFC] rounded-lg border border-[#E2E8F0] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-emerald-600 mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#0F172A] block font-bold">Physical Part Stamping:</strong>
                                Examine bearing race or valve housing for stamped manufacturer codes (e.g. 6204-2RS).
                            </div>
                        </div>
                        <div class="p-3 bg-[#F8FAFC] rounded-lg border border-[#E2E8F0] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-emerald-600 mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#0F172A] block font-bold">Installation Support Requirement:</strong>
                                Confirm whether on-site technician labor is needed to dismantle and align the replacement.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Emergency Helpline Card -->
                <div class="bg-gradient-to-br from-[#0F172A] to-[#1E293B] text-white rounded-2xl p-6 space-y-4 border border-slate-700 shadow-md">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg bg-[#EA580C] text-white flex items-center justify-center font-bold text-base shrink-0">
                            <i class="fa-solid fa-tower-broadcast"></i>
                        </div>
                        <div>
                            <span class="text-[10px] text-orange-400 font-mono font-bold uppercase tracking-wider block">DISPATCH PROTOCOL</span>
                            <h4 class="text-base font-bold text-white m-0">Rapid Breakdown Triage</h4>
                        </div>
                    </div>
                    <p class="text-xs text-slate-300 leading-relaxed m-0">
                        Submitting an emergency request broadcasts machine specifications and stamped OEM part numbers directly to regional suppliers with matching inventory.
                    </p>
                    <div class="pt-1">
                        <div class="p-3 bg-slate-800/80 border border-slate-700 rounded-xl text-xs text-slate-300 text-center font-mono">
                            <span class="text-orange-400 font-bold block mb-1">Target Response: &lt; 2 Hours</span>
                            <span class="text-[11px] text-slate-400">Simulated vendor notification active for academic demonstration</span>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>

