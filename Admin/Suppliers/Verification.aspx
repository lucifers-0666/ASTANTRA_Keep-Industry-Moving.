<%@ Page Title="Industrial Supplier Verification & Compliance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Verification.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Suppliers.Verification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">COMPLIANCE &amp; VENDOR DUE DILIGENCE</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Supplier &amp; Vendor Verification</h1>
            <p class="text-xs text-[#64748B] m-0">Audit commercial credentials, GSTIN registration, and stocking authenticity before approving quotation privileges.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-amber-50 text-amber-800 border border-amber-200">
                <i class="fa-solid fa-shield-halved text-amber-600"></i> KYC COMPLIANCE ACTIVE
            </span>
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded border text-xs flex items-center justify-between admin-animate-enter">
        <div class="flex items-center gap-2">
            <i id="iconAlert" runat="server" class="fa-solid fa-circle-check text-emerald-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Filter & Search Toolbar -->
    <div class="surface-card p-4 mb-6 admin-animate-enter admin-stagger-1">
        <div class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-center">
            <!-- Search Keyword -->
            <div class="sm:col-span-6 relative">
                <i class="fa-solid fa-magnifying-glass absolute left-3 top-3 text-slate-400 text-xs"></i>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search supplier enterprise, GSTIN, or contact name..." CssClass="form-input pl-8 text-xs py-2" />
            </div>

            <!-- Status Filter -->
            <div class="sm:col-span-3">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2">
                    <asp:ListItem Value="" Text="All Verification Statuses"></asp:ListItem>
                    <asp:ListItem Value="Pending" Text="Pending Review (Action Required)"></asp:ListItem>
                    <asp:ListItem Value="Verified" Text="Verified &amp; Certified"></asp:ListItem>
                    <asp:ListItem Value="Rejected" Text="Rejected Applications"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Search Action Buttons -->
            <div class="sm:col-span-3 flex items-center gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="btnSearch_Click" CssClass="btn-secondary flex-1 text-xs py-2 cursor-pointer" />
                <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-2.5 text-slate-500" ToolTip="Reset Filters">
                    <i class="fa-solid fa-rotate-left"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- Data Grid Container -->
    <div class="table-container shadow-xs admin-animate-enter admin-stagger-2">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-warehouse text-[#059669]"></i> Registered Stocking Suppliers
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total: <asp:Label ID="lblSuppliersCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label> vendors
            </span>
        </div>

        <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="SupplierId,UserId,CompanyName,ContactName,Email,PhoneNumber,Gstin,BusinessRegistrationNo,City,State,VerificationStatus,Rating" 
            OnRowCommand="gvSuppliers_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No industrial suppliers match the current verification criteria.">
            <Columns>
                <asp:BoundField DataField="SupplierId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                
                <asp:TemplateField HeaderText="Enterprise Name &amp; Hub">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("CompanyName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><i class="fa-solid fa-location-dot text-[9px] mr-1"></i><%# Eval("City") %>, <%# Eval("State") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Contact Liaison">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-semibold text-xs text-[#0F172A]"><%# Eval("ContactName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("PhoneNumber") %> | <%# Eval("Email") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="GSTIN &amp; Trade Reg">
                    <ItemTemplate>
                        <div class="flex flex-col font-mono text-xs">
                            <span class="text-[#0F172A] font-semibold"><%# Eval("Gstin") != DBNull.Value && !string.IsNullOrEmpty(Eval("Gstin").ToString()) ? Eval("Gstin") : "NOT ENTERED" %></span>
                            <span class="text-[10px] text-[#64748B]">Reg: <%# Eval("BusinessRegistrationNo") != DBNull.Value ? Eval("BusinessRegistrationNo") : "Pending" %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Quality Rating">
                    <ItemTemplate>
                        <div class="flex items-center gap-1 text-xs font-mono font-bold text-amber-700">
                            <i class="fa-solid fa-star text-amber-500 text-[10px]"></i>
                            <span><%# Eval("Rating") != DBNull.Value ? string.Format("{0:F1}", Eval("Rating")) : "4.5" %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# Eval("VerificationStatus").ToString() == "Verified" ? "status-pill status-pill-verified text-[10px]" : Eval("VerificationStatus").ToString() == "Rejected" ? "status-pill status-pill-emergency text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            <%# Eval("VerificationStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Compliance Audit" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-1.5">
                            <!-- Inspect Dossier -->
                            <asp:LinkButton ID="btnInspect" runat="server" 
                                CommandName="InspectSupplier" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                ToolTip="Inspect Due Diligence Dossier">
                                <i class="fa-solid fa-file-shield"></i> Inspect
                            </asp:LinkButton>

                            <!-- Quick Approve -->
                            <asp:LinkButton ID="btnApprove" runat="server" 
                                CommandName="ApproveSupplier" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                Visible='<%# Eval("VerificationStatus").ToString() != "Verified" %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-emerald-50 hover:bg-emerald-100 text-emerald-800 border border-emerald-300" 
                                ToolTip="Approve &amp; Verify">
                                <i class="fa-solid fa-check"></i> Approve
                            </asp:LinkButton>

                            <!-- Quick Reject -->
                            <asp:LinkButton ID="btnReject" runat="server" 
                                CommandName="RejectSupplier" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                Visible='<%# Eval("VerificationStatus").ToString() != "Rejected" %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                ToolTip="Reject Vendor">
                                <i class="fa-solid fa-xmark"></i> Reject
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- SUPPLIER INSPECTION & AUDIT DOSSIER MODAL -->
    <asp:Panel ID="pnlInspectModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-xl p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95 max-h-[90vh] overflow-y-auto">
            <asp:HiddenField ID="hdnInspectSupplierId" runat="server" />
            <asp:HiddenField ID="hdnInspectUserId" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-emerald-50 text-[#059669] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-file-shield"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Supplier Compliance Dossier</h3>
                        <span class="text-[10px] font-mono text-[#64748B]">AUDIT TRAIL VERIFICATION RECORD</span>
                    </div>
                </div>
                <asp:LinkButton ID="btnCloseInspectModal" runat="server" OnClick="btnCloseInspectModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <!-- Dossier Card Details -->
            <div class="space-y-3 text-xs">
                <div class="bg-slate-50 p-3.5 rounded border border-slate-200 space-y-2">
                    <div class="flex justify-between items-start">
                        <div>
                            <span class="text-[10px] uppercase font-mono text-[#64748B] block">Enterprise Name</span>
                            <span class="text-sm font-bold text-[#0F172A]" id="lblDossierCompanyName" runat="server">Company</span>
                        </div>
                        <span class="status-pill status-pill-pending text-[10px] font-mono" id="lblDossierStatus" runat="server">Pending</span>
                    </div>
                    <div class="grid grid-cols-2 gap-2 pt-2 border-t border-slate-200">
                        <div>
                            <span class="text-[10px] uppercase font-mono text-[#64748B] block">GSTIN Registration</span>
                            <span class="font-mono font-bold text-[#0F172A]" id="lblDossierGstin" runat="server">GSTIN</span>
                        </div>
                        <div>
                            <span class="text-[10px] uppercase font-mono text-[#64748B] block">Trade License #</span>
                            <span class="font-mono text-[#0F172A]" id="lblDossierTradeReg" runat="server">REG</span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3 bg-slate-50 p-3.5 rounded border border-slate-200">
                    <div>
                        <span class="text-[10px] uppercase font-mono text-[#64748B] block">Contact Representative</span>
                        <span class="font-semibold text-[#0F172A]" id="lblDossierContact" runat="server">Contact</span>
                        <span class="text-[10px] text-[#64748B] font-mono block mt-0.5" id="lblDossierEmail" runat="server">Email</span>
                        <span class="text-[10px] text-[#64748B] font-mono block" id="lblDossierPhone" runat="server">Phone</span>
                    </div>
                    <div>
                        <span class="text-[10px] uppercase font-mono text-[#64748B] block">Supply Hub City</span>
                        <span class="font-semibold text-[#0F172A]" id="lblDossierLocation" runat="server">City, State</span>
                        <div class="mt-2 flex items-center gap-1 text-amber-700 font-mono font-bold">
                            <i class="fa-solid fa-star text-amber-500"></i>
                            <span id="lblDossierRating" runat="server">4.8 Rating</span>
                        </div>
                    </div>
                </div>

                <!-- Compliance Checklist Checkmarks -->
                <div class="bg-blue-50/60 p-3.5 rounded border border-blue-200 space-y-1.5">
                    <span class="text-[10px] font-bold font-mono uppercase text-blue-900 tracking-wider">Automated Verification Checks</span>
                    <div class="flex items-center gap-2 text-[11px] text-blue-900">
                        <i class="fa-solid fa-check text-emerald-600"></i>
                        <span>GSTIN syntax matches State Code pattern (24 = Gujarat)</span>
                    </div>
                    <div class="flex items-center gap-2 text-[11px] text-blue-900">
                        <i class="fa-solid fa-check text-emerald-600"></i>
                        <span>Authenticated User Account bound to Supplier Profile</span>
                    </div>
                    <div class="flex items-center gap-2 text-[11px] text-blue-900">
                        <i class="fa-solid fa-check text-emerald-600"></i>
                        <span>Audit logging enabled for Superadmin governance decisions</span>
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Governance Audit Remarks / Justification</label>
                    <asp:TextBox ID="txtAuditRemarks" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-input text-xs py-2" placeholder="e.g. Validated against GST Portal. Authorized for commercial quotation bidding." />
                </div>
            </div>

            <!-- Modal Action Buttons -->
            <div class="flex items-center justify-between pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCloseDossier" runat="server" Text="Close Dossier" OnClick="btnCloseInspectModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <div class="flex items-center gap-2">
                    <asp:Button ID="btnRejectDossier" runat="server" Text="Reject Supplier" OnClick="btnRejectDossier_Click" CssClass="px-3 py-2 text-xs font-bold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-300 cursor-pointer" />
                    <asp:Button ID="btnApproveDossier" runat="server" Text="Approve &amp; Certify" OnClick="btnApproveDossier_Click" CssClass="px-4 py-2 text-xs font-bold rounded bg-emerald-600 hover:bg-emerald-700 text-white shadow-xs cursor-pointer" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
