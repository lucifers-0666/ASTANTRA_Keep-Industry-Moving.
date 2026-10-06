<%@ Page Title="Emergency Breakdown Sourcing Desk" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Emergency.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Emergency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Submit high-priority emergency spare-part breakdown requests to broadcast to regional suppliers and mobilize on-call field technicians." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10">
        <div class="astantra-container space-y-2 text-left">
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

    <div class="astantra-container py-8 space-y-8">
        
        <!-- 2. Breakdown Response Sequence (4 Steps) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
                <span class="font-mono text-[11px] font-bold text-[#E87519] bg-[#FFF3EB] px-2 py-0.5 rounded-[2px] border border-[#FED7AA]">STEP 01</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">1. Log Stoppage</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Submit machine model, stamped OEM part numbers, and observed failure symptoms.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
                <span class="font-mono text-[11px] font-bold text-[#E87519] bg-[#FFF3EB] px-2 py-0.5 rounded-[2px] border border-[#FED7AA]">STEP 02</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">2. Regional Broadcast</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Alert regional stockists within geographic proximity possessing matching inventory.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
                <span class="font-mono text-[11px] font-bold text-[#E87519] bg-[#FFF3EB] px-2 py-0.5 rounded-[2px] border border-[#FED7AA]">STEP 03</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">3. Stock Confirmation</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Suppliers verify shelf inventory, expedited courier pickup, or same-day freight.
                </p>
            </div>

            <div class="bg-white p-4 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
                <span class="font-mono text-[11px] font-bold text-[#18865B] bg-[#E8F5F0] px-2 py-0.5 rounded-[2px] border border-[#A7F3D0]">STEP 04</span>
                <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">4. Dispatch &amp; Fitting</h3>
                <p class="text-xs text-[#5F6B7A] leading-relaxed m-0">
                    Part is expedited to plant while certified on-call technicians are mobilized for on-site fitting.
                </p>
            </div>
        </div>

        <!-- 3. Form & Checklist Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            
            <!-- Left: Interactive Emergency Sourcing Form (Preserved Server Controls) -->
            <div class="lg:col-span-7 bg-white p-6 sm:p-7 rounded-[3px] border border-[#D5DCE3] space-y-4 shadow-xs text-left">
                <div class="flex items-center justify-between border-b border-[#D5DCE3] pb-3">
                    <div class="flex items-center gap-2">
                        <div class="card-icon-box--sm bg-[#E87519] text-white">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <div>
                            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Broadcast Emergency Request</h3>
                            <span class="text-xs text-[#5F6B7A] font-mono">PRIORITY NOTIFICATION DESK</span>
                        </div>
                    </div>
                    <span class="text-xs font-mono font-bold text-[#D9650E] uppercase tracking-wider">Priority Broadcast</span>
                </div>

                <!-- Upfront Authentication Context Banner -->
                <div class="p-3 rounded-[2px] bg-[#F7F8FA] border border-[#D5DCE3] text-xs text-[#5F6B7A] flex items-start gap-2.5">
                    <i class="fa-solid fa-circle-info text-[#1769E0] mt-0.5 shrink-0 text-sm"></i>
                    <div>
                        <strong class="text-[#202833] font-bold block mb-0.5">Factory Account Verification:</strong>
                        <span>Emergency dispatching transmits live alerts to stocking vendors. You may enter equipment details below; you will be prompted to authenticate with a Factory account before final dispatch.</span>
                    </div>
                </div>

                <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="p-3.5 rounded-[2px] bg-[#EBF2FD] border border-[#B6D4FA] text-xs text-[#17212F] space-y-2">
                    <div class="flex items-center gap-1.5 text-[#1769E0] font-bold">
                        <i class="fa-solid fa-circle-info"></i>
                        <span>Factory Sign In Required to Broadcast</span>
                    </div>
                    <p class="m-0 leading-relaxed text-[#5F6B7A]">Your equipment breakdown details are validated. Please sign in with your verified Factory Buyer account to dispatch this broadcast to stocking suppliers.</p>
                    <div class="pt-1 flex items-center gap-2">
                        <a href="~/Account/Login.aspx?returnUrl=~/Public/Emergency.aspx" runat="server" class="btn-primary text-xs py-1.5 px-3 font-bold inline-flex items-center gap-1">
                            <i class="fa-solid fa-right-to-bracket text-[10px]"></i> Sign In to Dispatch →
                        </a>
                        <a href="~/Account/Register.aspx" runat="server" class="btn-secondary text-xs py-1.5 px-3 font-bold">
                            Register Factory
                        </a>
                    </div>
                </asp:Panel>

                <div class="space-y-3.5 text-xs">
                    <div>
                        <div class="flex items-center justify-between">
                            <label class="form-label" for="<%= txtMachineName.ClientID %>">Equipment / Machine Name <span class="text-red-500">*</span></label>
                            <span class="text-[11px] text-[#8792A0] font-mono">* Required fields</span>
                        </div>
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

            <!-- Right: Breakdown Triage Checklist & Practical Advice -->
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

                <!-- Plant Triage Advice -->
                <div class="bg-white rounded-[3px] p-5 sm:p-6 space-y-3 border border-[#D7DDE4] shadow-[0_2px_8px_-2px_rgba(20,35,55,0.04)] text-left">
                    <div class="flex items-center gap-2.5">
                        <div class="card-icon-box--sm bg-[#FEF4EC] text-[#D9650E] border border-[#FAD7BE] shrink-0">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                        <div>
                            <span class="text-[10px] text-[#D9650E] font-mono font-bold uppercase tracking-wider block">PLANT SAFETY &amp; TRIAGE</span>
                            <h4 class="text-sm font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Immediate Actions While Sourcing</h4>
                        </div>
                    </div>
                    <ul class="text-xs text-[#667180] leading-relaxed m-0 pl-4 list-disc space-y-1.5">
                        <li><strong>Isolate Equipment:</strong> Apply Lockout/Tagout (LOTO) protocols to ensure plant personnel safety.</li>
                        <li><strong>Photograph Nameplate:</strong> Capture clear images of motor/pump data plates and stamped component numbers.</li>
                        <li><strong>Record Fault Codes:</strong> Note exact PLC, servo drive, or VFD alarm codes to assist responding technicians.</li>
                    </ul>
                    <div class="p-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[2px] text-[11px] text-[#5F6B7A] text-center font-mono">
                        <span>Regional stockist notifications are prioritized based on geographic proximity.</span>
                    </div>
                </div>

            </div>

        </div>

    </div>
</asp:Content>

