<%@ Page Title="Supplier Verification" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Verification.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Suppliers.Verification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Audit industrial supplier registration credentials, GSTIN documentation, and trade licenses." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 overflow-y-auto p-8">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
            <div>
                <span class="text-xs font-bold text-emerald-600 uppercase tracking-wider">Compliance & Due Diligence</span>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight m-0">Supplier & Vendor Verification</h1>
                <p class="text-xs text-slate-500 m-0 mt-1">Audit business registration numbers and GSTIN credentials before onboarding stocking suppliers.</p>
            </div>
            <div class="flex items-center gap-3">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="text-xs px-3 py-2 border border-slate-300 rounded-lg bg-white">
                    <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                    <asp:ListItem Value="Pending" Text="Pending Review"></asp:ListItem>
                    <asp:ListItem Value="Verified" Text="Verified / Approved"></asp:ListItem>
                    <asp:ListItem Value="Rejected" Text="Rejected"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <!-- Alert Notification -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-emerald-600"></i>
                <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Suppliers Verification Table -->
        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-4 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
                <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">
                    Industrial Supplier Registrations (<asp:Label ID="lblSuppliersCount" runat="server" Text="0"></asp:Label>)
                </h2>
            </div>

            <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False" DataKeyNames="SupplierId,UserId" OnRowCommand="gvSuppliers_RowCommand" CssClass="w-full text-left text-xs border-collapse">
                <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase tracking-wider border-b border-slate-200 p-3" />
                <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                <Columns>
                    <asp:BoundField DataField="SupplierId" HeaderText="ID" ItemStyle-CssClass="p-3 font-mono text-slate-500" />
                    <asp:BoundField DataField="CompanyName" HeaderText="Enterprise Name" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                    <asp:BoundField DataField="ContactName" HeaderText="Contact Person" ItemStyle-CssClass="p-3 text-slate-700" />
                    <asp:BoundField DataField="Gstin" HeaderText="GSTIN No." ItemStyle-CssClass="p-3 font-mono text-slate-800" NullDisplayText="N/A" />
                    <asp:BoundField DataField="BusinessRegistrationNo" HeaderText="Trade Reg #" ItemStyle-CssClass="p-3 font-mono text-slate-600" NullDisplayText="N/A" />
                    <asp:BoundField DataField="City" HeaderText="Hub City" ItemStyle-CssClass="p-3 text-slate-600" />
                    <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-bold <%# Eval("VerificationStatus").ToString() == "Verified" ? "bg-emerald-100 text-emerald-800" : Eval("VerificationStatus").ToString() == "Rejected" ? "bg-rose-100 text-rose-800" : "bg-amber-100 text-amber-800" %>">
                                <%# Eval("VerificationStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Audit Actions" ItemStyle-CssClass="p-3 text-right">
                        <ItemTemplate>
                            <div class="flex items-center justify-end gap-2">
                                <asp:Button ID="btnApprove" runat="server" Text="Approve" CommandName="ApproveSupplier" CommandArgument='<%# Container.DataItemIndex %>' Visible='<%# Eval("VerificationStatus").ToString() != "Verified" %>' CssClass="text-emerald-700 hover:text-emerald-900 text-[11px] font-bold cursor-pointer bg-emerald-50 px-2.5 py-1 rounded border border-emerald-200" />
                                <asp:Button ID="btnReject" runat="server" Text="Reject" CommandName="RejectSupplier" CommandArgument='<%# Container.DataItemIndex %>' Visible='<%# Eval("VerificationStatus").ToString() != "Rejected" %>' CssClass="text-rose-700 hover:text-rose-900 text-[11px] font-bold cursor-pointer bg-rose-50 px-2.5 py-1 rounded border border-rose-200" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

