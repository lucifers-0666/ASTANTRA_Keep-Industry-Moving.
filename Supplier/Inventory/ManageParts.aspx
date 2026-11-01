<%@ Page Title="Manage Supplier Inventory" Language="C#" MasterPageFile="~/MasterPages/Supplier.Master" AutoEventWireup="true" CodeBehind="ManageParts.aspx.cs" Inherits="IndustrialSparePartPortal.Supplier.Inventory.ManageParts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Manage spare parts inventory, unit prices, available quantities, and dispatch lead times." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">SUPPLIER WAREHOUSE &amp; STOCK</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Warehouse Inventory Catalog
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    List spare parts in stock, set competitive unit pricing, and maintain delivery lead-time estimates.
                </p>
            </div>
            <asp:Button ID="btnToggleAddForm" runat="server" Text="+ Add Stock Entry" OnClick="btnToggleAddForm_Click"
                CssClass="btn-primary text-xs py-2 px-3.5 font-bold cursor-pointer bg-[#059669] hover:bg-[#047857]" />
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
        </div>
    </asp:Panel>

    <!-- Add / Update Stock Entry Card -->
    <asp:Panel ID="pnlAddStock" runat="server" Visible="false" CssClass="bg-white rounded-[3px] border border-[#CBD5E1] p-6 mb-6 shadow-sm text-left">
        <h2 class="text-sm font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0 mb-4 pb-2 border-b border-[#E2E8F0]">
            Add or Update Stock Item
        </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 mb-4">
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Catalog Spare Part *</label>
                <asp:DropDownList ID="ddlCatalogPart" runat="server" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#059669]">
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Unit Price (₹) *</label>
                <asp:TextBox ID="txtUnitPrice" runat="server" placeholder="e.g. 4500.00" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#059669] font-mono"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Stock Quantity *</label>
                <asp:TextBox ID="txtStockQty" runat="server" placeholder="e.g. 25" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#059669] font-mono"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Availability Status</label>
                <asp:DropDownList ID="ddlAvailability" runat="server" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#059669]">
                    <asp:ListItem Value="InStock" Text="In Stock" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="LowStock" Text="Low Stock"></asp:ListItem>
                    <asp:ListItem Value="OutOfStock" Text="Out of Stock"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Lead Time (Days)</label>
                <asp:TextBox ID="txtLeadTime" runat="server" Text="2" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#059669] font-mono"></asp:TextBox>
            </div>
        </div>
        <div class="flex gap-2">
            <asp:Button ID="btnSaveStock" runat="server" Text="Save Stock Entry" OnClick="btnSaveStock_Click"
                CssClass="btn-primary text-xs py-2 px-4 font-bold bg-[#059669] hover:bg-[#047857] cursor-pointer" />
            <asp:Button ID="btnCancelStock" runat="server" Text="Cancel" OnClick="btnCancelStock_Click"
                CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- Inventory Data Table -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden text-left">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Current Warehouse Inventory (<asp:Label ID="lblInventoryCount" runat="server" Text="0"></asp:Label>)
            </h2>
        </div>

        <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" DataKeyNames="InventoryId" OnRowCommand="gvInventory_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="p-3 font-mono font-bold text-[#059669]" />
                <asp:BoundField DataField="PartName" HeaderText="Part Name" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="p-3 text-[#5F6B7A]" />
                <asp:TemplateField HeaderText="Unit Price" ItemStyle-CssClass="p-3 font-mono font-bold text-[#17212F]">
                    <ItemTemplate>
                        ₹<%# Convert.ToDecimal(Eval("UnitPrice")).ToString("N2") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="StockQuantity" HeaderText="Qty Available" ItemStyle-CssClass="p-3 font-mono text-[#17212F]" />
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("AvailabilityStatus").ToString() == "LowStock" ? "bg-amber-100 text-amber-800 border-amber-300" : "bg-red-100 text-red-800 border-red-300" %> text-[10px]">
                            <%# Eval("AvailabilityStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lead Time" ItemStyle-CssClass="p-3 font-mono text-[#5F6B7A]">
                    <ItemTemplate>
                        <%# Eval("LeadTimeDays") %> days
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteStock" CommandArgument="<%# Container.DataItemIndex %>"
                            OnClientClick="return confirm('Are you sure you want to remove this stock entry?');"
                            CssClass="btn-secondary text-[10px] py-1 px-2.5 font-bold text-red-600 hover:text-red-700 cursor-pointer" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-boxes-stacked text-3xl mb-2 text-[#CBD5E1]"></i>
                    <p class="text-xs font-semibold">No inventory items listed yet.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0">Click "+ Add Stock Entry" above to add spare parts to your warehouse catalog.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

