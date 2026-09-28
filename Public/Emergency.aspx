<%@ Page Title="Emergency Breakdown Sourcing Desk" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Emergency.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Emergency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Submit high-priority emergency spare-part breakdown requests to broadcast to regional suppliers and mobilize on-call field technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. HEADER BANNER                                                             -->
    <!-- Serious industrial tone, not an orange marketing page                        -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#E87519] uppercase tracking-wider block">
                Priority Procurement Desk
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                Machine Breakdown? Get Emergency Procurement Support.
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                Broadcast critical component requirements across regional verified stockists and alert on-call field engineers to minimize plant downtime.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- ============================================================================ -->
            <!-- 2. EMERGENCY SOURCING FORM                                                   -->
            <!-- Clean white surface with subtle top border accent                            -->
            <!-- ============================================================================ -->
            <div class="lg:col-span-7 surface-card p-6 sm:p-8 space-y-5 text-left border-t-4 border-t-[#E87519]">
                <div class="border-b border-[#D9DEE5] pb-3">
                    <h2 class="text-lg font-bold text-[#111827] m-0">Broadcast Emergency Request</h2>
                    <p class="text-xs text-[#5F6B7A] m-0 mt-0.5">Fill in machine and part details for immediate vendor dispatch</p>
                </div>

                <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="p-3.5 rounded bg-blue-50 border border-blue-200 text-xs text-[#111827] space-y-1">
                    <strong class="font-bold block text-[#1769E0]"><i class="fa-solid fa-circle-info mr-1"></i> Sign In Required to Broadcast</strong>
                    <span>Your emergency request details are noted. Please sign in with your Factory account to dispatch the broadcast.</span>
                </asp:Panel>

                <div class="space-y-4 text-xs">
                    <div>
                        <label class="form-label" for="<%= txtMachineName.ClientID %>">Machine / Equipment Name <span class="text-red-500">*</span></label>
                        <asp:TextBox ID="txtMachineName" runat="server" CssClass="form-input" Placeholder="e.g. CNC Lathe X200, 500T Hydraulic Press, Air Compressor 75HP"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= txtPartNumber.ClientID %>">Part Required / OEM Part # <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-input font-mono" Placeholder="e.g. 6210-2RS, PART-HYD-001"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtQuantity.ClientID %>">Quantity Required <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" CssClass="form-input font-mono"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= ddlUrgency.ClientID %>">Priority / Urgency</label>
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
                        <label class="form-label" for="<%= txtDescription.ClientID %>">Problem Description / Failure Symptoms</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-input font-mono text-xs" Placeholder="Describe observed symptoms (e.g. pressure drop below 50 bar, servo drive alarm code 0x4F, bearing overheating)..."></asp:TextBox>
                    </div>

                    <div class="pt-2">
                        <asp:Button ID="btnSubmitEmergency" runat="server" Text="Submit Emergency Request" OnClick="btnSubmitEmergency_Click" CssClass="btn-emergency w-full justify-center text-xs py-2.5" />
                    </div>

                    <p class="text-[11px] text-[#5F6B7A] text-center m-0 font-mono">
                        <i class="fa-solid fa-shield-halved mr-1"></i> Requires authenticated Factory account. Unregistered users are redirected to login.
                    </p>
                </div>
            </div>

            <!-- ============================================================================ -->
            <!-- 3. TRIAGE CHECKLIST & DISPATCH PROTOCOL                                      -->
            <!-- ============================================================================ -->
            <div class="lg:col-span-5 space-y-6 text-left">
                
                <!-- Triage Checklist -->
                <div class="surface-card p-6 space-y-4">
                    <div class="border-b border-[#D9DEE5] pb-2">
                        <span class="text-xs font-mono font-bold text-[#1769E0] uppercase block">Pre-Dispatch Checklist</span>
                        <h3 class="text-base font-bold text-[#111827] m-0 mt-0.5">Verification Checklist</h3>
                    </div>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                        Gather these specifications to ensure suppliers dispatch exact replacement tolerances:
                    </p>

                    <div class="space-y-3 text-xs text-[#172033]">
                        <div class="p-3 bg-[#F8F9FA] rounded border border-[#E5E9EE] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#111827] block font-bold">OEM Nameplate Verification:</strong>
                                Check motor/pump rating plate for serial number, voltage, flow rate, and pressure.
                            </div>
                        </div>
                        <div class="p-3 bg-[#F8F9FA] rounded border border-[#E5E9EE] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#111827] block font-bold">Physical Part Stamping:</strong>
                                Examine bearing race or valve housing for stamped manufacturer codes (e.g. 6204-2RS).
                            </div>
                        </div>
                        <div class="p-3 bg-[#F8F9FA] rounded border border-[#E5E9EE] flex items-start gap-2.5">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0"></i>
                            <div>
                                <strong class="text-[#111827] block font-bold">Installation Support:</strong>
                                Confirm whether on-site technician labor is needed to dismantle and align the replacement.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Response SLA Card -->
                <div class="bg-[#101C2C] text-white rounded-lg p-5 space-y-2 border border-[#22354E]">
                    <div class="flex items-center gap-2 text-xs font-mono font-bold text-[#E87519] uppercase">
                        <i class="fa-solid fa-clock"></i> Target SLA
                    </div>
                    <h4 class="text-base font-bold text-white m-0">&lt; 2 Hours Turnaround</h4>
                    <p class="text-xs text-slate-300 leading-relaxed m-0">
                        Broadcasts alert regional suppliers within proximity holding active category inventory and notifies certified local technicians.
                    </p>
                </div>

            </div>

        </div>
    </div>
</asp:Content>

