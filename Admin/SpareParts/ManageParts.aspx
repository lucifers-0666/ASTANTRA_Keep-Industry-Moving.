<%@ Page Title="Master Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageParts.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.SpareParts.ManageParts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Master industrial spare parts catalog management and technical specification database." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 overflow-y-auto p-8">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
            <div>
                <span class="text-xs font-bold text-amber-600 uppercase tracking-wider">Catalog Architecture</span>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight m-0">Master Spare Parts Catalog</h1>
                <p class="text-xs text-slate-500 m-0 mt-1">Manage global part numbers, technical specifications, and compatibility mappings.</p>
            </div>
            <asp:Button ID="btnToggleAddForm" runat="server" Text="+ Register New Part" OnClick="btnToggleAddForm_Click" CssClass="btn-primary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>

        <!-- Alert Notification -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-emerald-600"></i>
                <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Add Part Drawer / Panel -->
        <asp:Panel ID="pnlAddPart" runat="server" Visible="false" CssClass="bg-white rounded-xl border border-slate-200 p-6 mb-6 shadow-sm">
            <h3 class="text-xs font-bold text-slate-700 uppercase tracking-wider mb-4 pb-2 border-b border-slate-100 flex items-center gap-2">
                <i class="fa-solid fa-gear text-amber-500"></i> Register Master Part Specification
            </h3>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Part Number (OEM) <span class="text-red-500">*</span></label>
                    <asp:TextBox ID="txtPartNumber" runat="server" placeholder="e.g. PART-BRG-005" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg font-mono font-bold"></asp:TextBox>
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Part Name <span class="text-red-500">*</span></label>
                    <asp:TextBox ID="txtPartName" runat="server" placeholder="e.g. Spherical Roller Bearing" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg font-semibold"></asp:TextBox>
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Category <span class="text-red-500">*</span></label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:DropDownList>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Compatible Machine</label>
                    <asp:DropDownList ID="ddlMachine" runat="server" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg">
                        <asp:ListItem Value="" Text="Universal (Any Industrial Machinery)"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Unit of Measure</label>
                    <asp:DropDownList ID="ddlUom" runat="server" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg">
                        <asp:ListItem Value="Piece" Text="Piece"></asp:ListItem>
                        <asp:ListItem Value="Set" Text="Set"></asp:ListItem>
                        <asp:ListItem Value="Meter" Text="Meter"></asp:ListItem>
                        <asp:ListItem Value="Pack" Text="Pack"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="mb-4">
                <label class="block text-xs font-semibold text-slate-700 mb-1">Technical Specifications / Engineering Drawing Data</label>
                <asp:TextBox ID="txtSpecs" runat="server" TextMode="MultiLine" Rows="2" placeholder="Dimensions (ID/OD/Width), load ratings, voltage, material grade..." CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg font-mono text-xs"></asp:TextBox>
            </div>

            <div class="flex justify-end gap-3">
                <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" OnClick="btnCancelAdd_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
                <asp:Button ID="btnSavePart" runat="server" Text="Save to Master Catalog" OnClick="btnSavePart_Click" CssClass="btn-primary text-xs py-2 px-5 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

        <!-- Parts Catalog Grid -->
        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-4 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
                <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">
                    Master Parts Catalog (<asp:Label ID="lblPartsCount" runat="server" Text="0"></asp:Label>)
                </h2>
            </div>

            <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="False" DataKeyNames="PartId" CssClass="w-full text-left text-xs border-collapse">
                <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase tracking-wider border-b border-slate-200 p-3" />
                <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                <Columns>
                    <asp:BoundField DataField="PartId" HeaderText="ID" ItemStyle-CssClass="p-3 font-mono text-slate-500" />
                    <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="p-3 font-mono font-bold text-blue-600" />
                    <asp:BoundField DataField="PartName" HeaderText="Part Name" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="p-3 text-slate-600" />
                    <asp:BoundField DataField="MachineName" HeaderText="Machine Compatibility" ItemStyle-CssClass="p-3 text-slate-600" NullDisplayText="Universal" />
                    <asp:BoundField DataField="TechnicalSpecs" HeaderText="Specifications" ItemStyle-CssClass="p-3 text-[11px] text-slate-500 max-w-xs truncate" />
                    <asp:BoundField DataField="UnitOfMeasure" HeaderText="UOM" ItemStyle-CssClass="p-3 text-slate-500 text-center" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

