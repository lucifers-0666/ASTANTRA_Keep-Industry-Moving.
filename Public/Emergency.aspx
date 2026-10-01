<%@ Page Title="Emergency Breakdown Sourcing Desk" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Emergency.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Emergency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Submit high-priority emergency spare-part breakdown requests to broadcast to regional suppliers and mobilize on-call field technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="text-xs font-mono font-bold text-[#D9650E] tracking-wider uppercase">
                Critical Breakdown Desk &middot; Priority Escalation
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                Emergency Breakdown Sourcing Desk
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                When an assembly line halts, every minute of idle capacity costs thousands. Broadcast critical component requirements across nearby verified stockists and alert on-call field engineers.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
        
        <!-- 2. Fast-Track Protocol Sequence (4 Steps) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#E87519] space-y-1.5 text-left">
                <span class="font-mono text-xs font-bold text-[#E87519]">STEP 01</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">1. Log Breakdown</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Submit machine model, stamped OEM part numbers, and observed failure symptoms.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#E87519] space-y-1.5 text-left">
                <span class="font-mono text-xs font-bold text-[#E87519]">STEP 02</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">2. Supplier Broadcast</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Platform alerts regional stockists within proximity possessing matching inventory.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#E87519] space-y-1.5 text-left">
                <span class="font-mono text-xs font-bold text-[#E87519]">STEP 03</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">3. Rapid Quotation</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Suppliers confirm ready shelf stock, expedited pickup, or same-day freight.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] border-l-4 border-l-[#18865B] space-y-1.5 text-left">
                <span class="font-mono text-xs font-bold text-[#18865B]">STEP 04</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">4. Priority Fitting</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Part is expedited to plant while on-call technicians are mobilized for on-site fitting.
                </p>
            </div>
        </div>

        <!-- 3. Form & Checklist Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            
            <!-- Left: Interactive Emergency Sourcing Form (Preserved Server Controls) -->
            <div class="lg:col-span-7 bg-white p-6 sm:p-7 rounded-[3px] border border-[#D5DCE3] space-y-4 shadow-xs text-left">
                <div class="flex items-center justify-between border-b border-[#D5DCE3] pb-3">
                    <div class="flex items-center gap-2">
                        <div class="w-7 h-7 rounded-[2px] bg-[#E87519] text-white flex items-center justify-center text-xs font-bold">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <div>
                            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Broadcast Emergency Request</h3>
                            <span class="text-xs text-[#5F6B7A] font-mono">PRIORITY NOTIFICATION DESK</span>
                        </div>
                    </div>
                    <span class="text-xs font-mono font-bold text-[#D9650E] uppercase tracking-wider">Priority Broadcast</span>
                </div>

                <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="p-3.5 rounded-[2px] bg-[#EBF2FD] border border-[#B6D4FA] text-xs text-[#17212F] space-y-1">
                    <strong class="font-bold block text-[#1769E0]"><i class="fa-solid fa-circle-info mr-1"></i> Sign In Required to Broadcast</strong>
                    <span>Your emergency request details are saved. Please sign in with your Factory account to dispatch the broadcast.</span>
                </asp:Panel>

                <div class="space-y-3.5 text-xs">
                    <div>
                        <label class="form-label" for="<%= txtMachineName.ClientID %>">Equipment / Machine Name <span class="text-red-500">*</span></label>
                        <asp:TextBox ID="txtMachineName" runat="server" CssClass="form-input" Placeholder="e.g. CNC Lathe X200, 500T Hydraulic Press, Air Compressor 75HP"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                        <div>
                            <label class="form-label" for="<%= txtPartNumber.ClientID %>">OEM Part # or Stamped Code <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-input font-mono" Placeholder="e.g. 6210-2RS, PART-HYD-001"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtQuantity.ClientID %>">Required Quantity <span class="text-red-500">*</span></label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" CssClass="form-input font-mono"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
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
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-input font-mono text-xs" Placeholder="Describe observed symptoms (e.g. hydraulic pressure dropped below 50 bar, servo alarm code 0x4F, bearing overheating)..."></asp:TextBox>
                    </div>

                    <div class="pt-1">
                        <asp:Button ID="btnSubmitEmergency" runat="server" Text="Dispatch Emergency Broadcast →" OnClick="btnSubmitEmergency_Click" CssClass="btn-emergency w-full justify-center text-xs py-2.5 font-bold cursor-pointer" />
                    </div>

                    <p class="text-[11px] text-[#5F6B7A] text-center m-0 font-mono">
                        <i class="fa-solid fa-lock mr-1"></i> Requires authenticated Factory account. Unregistered users are redirected to login.
                    </p>
                </div>
            </div>

            <!-- Right: Breakdown Triage Checklist & Protocol Details -->
            <div class="lg:col-span-5 space-y-4">
                
                <!-- Triage Checklist -->
                <div class="bg-white p-5 sm:p-6 rounded-[3px] border border-[#D5DCE3] space-y-3 text-left">
                    <div class="text-xs font-mono font-bold text-[#1769E0] tracking-wider uppercase">
                        Pre-Dispatch Checklist
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Plant Breakdown Triage Checklist</h3>
                    <p class="text-xs text-[#5F6B7A] m-0 leading-relaxed">
                        Gather these specifications to ensure suppliers dispatch exact replacement tolerances:
                    </p>

                    <div class="space-y-2 text-xs text-[#2C394B]">
                        <div class="p-2.5 bg-[#F1F3F5] rounded-[2px] border border-[#D5DCE3] flex items-start gap-2">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0 text-xs"></i>
                            <div>
                                <strong class="text-[#17212F] block font-bold">OEM Nameplate Verification:</strong>
                                Check motor/pump rating plate for serial number, voltage, flow rate, and pressure.
                            </div>
                        </div>
                        <div class="p-2.5 bg-[#F1F3F5] rounded-[2px] border border-[#D5DCE3] flex items-start gap-2">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0 text-xs"></i>
                            <div>
                                <strong class="text-[#17212F] block font-bold">Physical Part Stamping:</strong>
                                Examine bearing race or valve housing for stamped manufacturer codes (e.g. 6210-2RS).
                            </div>
                        </div>
                        <div class="p-2.5 bg-[#F1F3F5] rounded-[2px] border border-[#D5DCE3] flex items-start gap-2">
                            <i class="fa-solid fa-check text-[#18865B] mt-0.5 shrink-0 text-xs"></i>
                            <div>
                                <strong class="text-[#17212F] block font-bold">Installation Support Requirement:</strong>
                                Confirm whether on-site technician labor is needed to dismantle and align the replacement.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Emergency Protocol in Refined Industrial Surface -->
                <div class="bg-white rounded-[3px] p-5 sm:p-6 space-y-3 border border-[#D7DDE4] shadow-[0_2px_8px_-2px_rgba(20,35,55,0.04)] text-left">
                    <div class="flex items-center gap-2.5">
                        <div class="w-8 h-8 rounded-[2px] bg-[#FEF4EC] text-[#D9650E] border border-[#FAD7BE] flex items-center justify-center font-bold text-sm shrink-0">
                            <i class="fa-solid fa-tower-broadcast"></i>
                        </div>
                        <div>
                            <span class="text-[10px] text-[#D9650E] font-mono font-bold uppercase tracking-wider block">DISPATCH PROTOCOL</span>
                            <h4 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Rapid Breakdown Triage</h4>
                        </div>
                    </div>
                    <p class="text-xs text-[#667180] leading-relaxed m-0">
                        Submitting an emergency request broadcasts machine specifications and stamped OEM part numbers directly to regional suppliers with matching inventory.
                    </p>
                    <div class="p-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[2px] text-xs text-[#667180] text-center font-mono">
                        <span class="text-[#D9650E] font-bold block mb-0.5">Target Response: &lt; 2 Hours</span>
                        <span class="text-[10px] text-[#8792A0]">Active priority queue protocol across regional suppliers</span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>

