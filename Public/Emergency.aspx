<%@ Page Title="Emergency Breakdown Sourcing Desk" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Emergency.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Emergency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/emergency.css") %>" rel="stylesheet" />
    <meta name="description" content="Submit high-priority emergency spare-part breakdown requests to broadcast to regional suppliers and mobilize on-call field technicians." />
    <script src="<%= ResolveUrl("~/Content/js/ux-utils.js") %>"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- HEADER -->
    <div style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 48px 0;">
        <div class="sf-container" style="max-width: 960px;">
            <span style="font-size: 12px; font-weight: 700; color: var(--sf-emergency); text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 8px;">
                Priority Procurement Desk
            </span>
            <h1 style="font-size: 28px; color: var(--sf-navy); margin: 0 0 12px 0;">Machine Breakdown? Get Emergency Procurement Support.</h1>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px;">
                Broadcast critical component requirements across regional verified stockists and alert on-call field engineers to minimize plant downtime.
            </p>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="sf-container" style="max-width: 960px; padding-top: 32px; padding-bottom: 64px;">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- EMERGENCY SOURCING FORM -->
            <div class="lg:col-span-7 sf-card" style="border-top: 4px solid var(--sf-emergency); padding: 32px;">
                <div style="border-bottom: 1px solid var(--sf-border); padding-bottom: 16px; margin-bottom: 24px;">
                    <h2 style="font-size: 18px; color: var(--sf-navy); margin: 0 0 4px 0;">Broadcast Emergency Request</h2>
                    <p style="font-size: 13px; color: var(--sf-text-muted); margin: 0;">Fill in machine and part details for immediate vendor dispatch</p>
                </div>

                <asp:Panel ID="pnlNotice" runat="server" Visible="false" style="padding: 16px; border-radius: var(--sf-radius-sm); background: rgba(23, 105, 224, 0.05); border: 1px solid rgba(23, 105, 224, 0.2); margin-bottom: 24px;">
                    <strong style="display: block; font-size: 13px; color: var(--sf-primary); margin-bottom: 4px;"><i class="fa-solid fa-circle-info"></i> Sign In Required to Broadcast</strong>
                    <span style="font-size: 13px; color: var(--sf-text);">Your emergency request details are noted. Please sign in with your Factory account to dispatch the broadcast.</span>
                </asp:Panel>

                <div style="display: flex; flex-direction: column; gap: 16px;">
                    <div>
                        <label class="sf-label" for="<%= txtMachineName.ClientID %>">Machine / Equipment Name <span style="color: #ef4444;">*</span></label>
                        <asp:TextBox ID="txtMachineName" runat="server" CssClass="sf-input" Placeholder="e.g. CNC Lathe X200, 500T Hydraulic Press"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="sf-label" for="<%= txtPartNumber.ClientID %>">Part Required / OEM Part # <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtPartNumber" runat="server" CssClass="sf-input" style="font-family: monospace;" Placeholder="e.g. 6210-2RS"></asp:TextBox>
                        </div>
                        <div>
                            <label class="sf-label" for="<%= txtQuantity.ClientID %>">Quantity Required <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" CssClass="sf-input" style="font-family: monospace;"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="sf-label" for="<%= ddlUrgency.ClientID %>">Priority / Urgency</label>
                            <asp:DropDownList ID="ddlUrgency" runat="server" CssClass="sf-input">
                                <asp:ListItem Value="Critical" Text="CRITICAL - Assembly Line Stopped"></asp:ListItem>
                                <asp:ListItem Value="Urgent" Text="URGENT - Failure Expected Within 24 Hrs"></asp:ListItem>
                                <asp:ListItem Value="Priority" Text="PRIORITY - Zero Safety Buffer Stock"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label class="sf-label" for="<%= txtCity.ClientID %>">Plant Location / City <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="sf-input" Placeholder="e.g. Pune MIDC, Sanand GIDC"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="sf-label" for="<%= txtDescription.ClientID %>">Problem Description / Failure Symptoms</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="sf-input" style="font-family: monospace; font-size: 13px;" Placeholder="Describe observed symptoms (e.g. pressure drop below 50 bar)..."></asp:TextBox>
                    </div>

                    <div style="margin-top: 8px;">
                        <asp:Button ID="btnSubmitEmergency" runat="server" Text="Submit Emergency Request" OnClick="btnSubmitEmergency_Click" CssClass="sf-btn sf-btn-emergency" style="width: 100%;" />
                    </div>

                    <p style="font-size: 11px; color: var(--sf-text-muted); text-align: center; margin: 8px 0 0 0; font-family: monospace;">
                        <i class="fa-solid fa-shield-halved"></i> Requires authenticated Factory account. Unregistered users are redirected to login.
                    </p>
                </div>
            </div>

            <!-- TRIAGE CHECKLIST -->
            <div class="lg:col-span-5" style="display: flex; flex-direction: column; gap: 24px;">
                <div class="sf-card" style="padding: 24px;">
                    <div style="border-bottom: 1px solid var(--sf-border); padding-bottom: 12px; margin-bottom: 16px;">
                        <span style="font-size: 11px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; font-family: monospace;">Pre-Dispatch Checklist</span>
                    </div>
                    <ul style="list-style: none; padding: 0; margin: 0; font-size: 13px; color: var(--sf-text); display: flex; flex-direction: column; gap: 12px;">
                        <li style="display: flex; gap: 12px; align-items: flex-start;">
                            <i class="fa-solid fa-circle-check" style="color: var(--sf-primary); margin-top: 3px;"></i>
                            <span>Confirm exact OEM part number from machine manual</span>
                        </li>
                        <li style="display: flex; gap: 12px; align-items: flex-start;">
                            <i class="fa-solid fa-circle-check" style="color: var(--sf-primary); margin-top: 3px;"></i>
                            <span>Take photos of the broken part or nameplate if possible</span>
                        </li>
                        <li style="display: flex; gap: 12px; align-items: flex-start;">
                            <i class="fa-solid fa-circle-check" style="color: var(--sf-primary); margin-top: 3px;"></i>
                            <span>Clear access around the machine for the field technician</span>
                        </li>
                    </ul>
                </div>

                <div class="sf-card" style="padding: 24px;">
                    <div style="border-bottom: 1px solid var(--sf-border); padding-bottom: 12px; margin-bottom: 16px;">
                        <span style="font-size: 11px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; font-family: monospace;">What Happens Next</span>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <div style="display: flex; gap: 16px;">
                            <div style="width: 24px; height: 24px; border-radius: 12px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; flex-shrink: 0;">1</div>
                            <div style="font-size: 13px; color: var(--sf-text);">Broadcast alert is sent to all verified stockists within 200km.</div>
                        </div>
                        <div style="display: flex; gap: 16px;">
                            <div style="width: 24px; height: 24px; border-radius: 12px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; flex-shrink: 0;">2</div>
                            <div style="font-size: 13px; color: var(--sf-text);">Suppliers reply instantly with priority quotations and lead times.</div>
                        </div>
                        <div style="display: flex; gap: 16px;">
                            <div style="width: 24px; height: 24px; border-radius: 12px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; flex-shrink: 0;">3</div>
                            <div style="font-size: 13px; color: var(--sf-text);">A certified field engineer is matched if diagnostic or installation support is required.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
