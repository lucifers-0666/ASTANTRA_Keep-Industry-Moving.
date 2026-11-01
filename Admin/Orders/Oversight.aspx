<%@ Page Title="Procurement & Emergency Oversight" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Oversight.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Orders.Oversight" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="System-wide oversight of commercial RFQs, procurement purchase orders, and critical breakdown emergency triage." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 overflow-y-auto p-8">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
            <div>
                <span class="text-xs font-bold text-red-600 uppercase tracking-wider">System Operations & Fulfilment</span>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight m-0">Commercial Orders & Emergency Oversight</h1>
                <p class="text-xs text-slate-500 m-0 mt-1">Cross-platform tracking of buyer RFQs, supplier order fulfillment, and priority equipment breakdown triage.</p>
            </div>
        </div>

        <!-- 1. Emergency Machine Breakdown Alerts -->
        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden mb-8">
            <div class="p-4 border-b border-slate-200 bg-red-50/50 flex justify-between items-center">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation text-red-600"></i>
                    <h2 class="text-xs font-bold text-red-950 uppercase tracking-wider m-0">Critical Breakdown SOS Alerts (<asp:Label ID="lblEmergencyCount" runat="server" Text="0"></asp:Label>)</h2>
                </div>
            </div>

            <asp:GridView ID="gvEmergency" runat="server" AutoGenerateColumns="False" CssClass="w-full text-left text-xs border-collapse">
                <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase p-3" />
                <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                <Columns>
                    <asp:BoundField DataField="EmergencyRequestId" HeaderText="SOS #" ItemStyle-CssClass="p-3 font-mono font-bold text-red-600" />
                    <asp:BoundField DataField="FactoryCompany" HeaderText="Reporting Plant" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                    <asp:BoundField DataField="MachineName" HeaderText="Affected Equipment" ItemStyle-CssClass="p-3 text-slate-800" />
                    <asp:BoundField DataField="LocationCity" HeaderText="Plant Location" ItemStyle-CssClass="p-3 text-slate-600" />
                    <asp:TemplateField HeaderText="Priority" ItemStyle-CssClass="p-3">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-red-100 text-red-800 border border-red-300">
                                ⚡ <%# Eval("PriorityLevel") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Status" HeaderText="Triage Status" ItemStyle-CssClass="p-3 font-semibold text-slate-700" />
                    <asp:BoundField DataField="CreatedAt" HeaderText="Logged Time" DataFormatString="{0:dd-MMM HH:mm}" ItemStyle-CssClass="p-3 text-slate-500 text-[11px]" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-6 text-center text-slate-500 text-xs">No active emergency breakdown alerts logged.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <!-- 2. System-wide Procurement Orders -->
        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden mb-8">
            <div class="p-4 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
                <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">Purchase Orders Fulfillment (<asp:Label ID="lblOrdersCount" runat="server" Text="0"></asp:Label>)</h2>
            </div>

            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="w-full text-left text-xs border-collapse">
                <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase p-3" />
                <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                <Columns>
                    <asp:BoundField DataField="OrderNumber" HeaderText="Order Number" ItemStyle-CssClass="p-3 font-mono font-bold text-blue-600" />
                    <asp:BoundField DataField="FactoryCompany" HeaderText="Buyer Plant" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                    <asp:BoundField DataField="SupplierCompany" HeaderText="Supplier" ItemStyle-CssClass="p-3 text-slate-800" />
                    <asp:TemplateField HeaderText="Total Amount" ItemStyle-CssClass="p-3 font-mono font-bold text-slate-900">
                        <ItemTemplate>
                            ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order Status" ItemStyle-CssClass="p-3">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-bold <%# Eval("OrderStatus").ToString() == "Delivered" ? "bg-emerald-100 text-emerald-800" : Eval("OrderStatus").ToString() == "Shipped" ? "bg-blue-100 text-blue-800" : "bg-amber-100 text-amber-800" %>">
                                <%# Eval("OrderStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="TrackingNumber" HeaderText="Consignment #" ItemStyle-CssClass="p-3 font-mono text-[11px]" NullDisplayText="-" />
                    <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-CssClass="p-3 text-slate-500 text-[11px]" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-6 text-center text-slate-500 text-xs">No purchase orders found in the system.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

