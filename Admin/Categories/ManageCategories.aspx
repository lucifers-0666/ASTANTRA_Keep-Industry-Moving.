<%@ Page Title="Manage Categories & Machines" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCategories.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Categories.ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Manage industrial part taxonomies, component categories, and machinery models." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 overflow-y-auto p-8">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
            <div>
                <span class="text-xs font-bold text-purple-600 uppercase tracking-wider">Taxonomy & Equipment Registry</span>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight m-0">Part Categories & Machine Models</h1>
                <p class="text-xs text-slate-500 m-0 mt-1">Configure component classification hierarchies and compatible machine profiles.</p>
            </div>
        </div>

        <!-- Alert Notification -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-emerald-600"></i>
                <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Two Column Layout: Add Category & Add Machine -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Add Category Card -->
            <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm">
                <h3 class="text-xs font-bold text-slate-700 uppercase tracking-wider mb-4 pb-2 border-b border-slate-100 flex items-center gap-2">
                    <i class="fa-solid fa-folder-plus text-purple-600"></i> Register New Category
                </h3>
                <div class="space-y-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Category Name <span class="text-red-500">*</span></label>
                        <asp:TextBox ID="txtCategoryName" runat="server" placeholder="e.g. Mechanical Fasteners" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Description</label>
                        <asp:TextBox ID="txtCategoryDesc" runat="server" placeholder="Component scope..." CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">FontAwesome Icon Class</label>
                        <asp:TextBox ID="txtCategoryIcon" runat="server" Text="fa-cogs" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg font-mono"></asp:TextBox>
                    </div>
                    <div class="pt-2 text-right">
                        <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" OnClick="btnAddCategory_Click" CssClass="btn-primary text-xs py-2 px-4 font-bold cursor-pointer" />
                    </div>
                </div>
            </div>

            <!-- Add Machine Card -->
            <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm">
                <h3 class="text-xs font-bold text-slate-700 uppercase tracking-wider mb-4 pb-2 border-b border-slate-100 flex items-center gap-2">
                    <i class="fa-solid fa-industry text-blue-600"></i> Register Industrial Machine
                </h3>
                <div class="space-y-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Machine Name <span class="text-red-500">*</span></label>
                        <asp:TextBox ID="txtMachineName" runat="server" placeholder="e.g. 5-Axis Milling Machine" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:TextBox>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1">Model Number</label>
                            <asp:TextBox ID="txtMachineModel" runat="server" placeholder="MILL-5X" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1">Manufacturer</label>
                            <asp:TextBox ID="txtMachineMfg" runat="server" placeholder="DMG MORI" CssClass="w-full text-xs px-3 py-2 border border-slate-300 rounded-lg"></asp:TextBox>
                        </div>
                    </div>
                    <div class="pt-2 text-right">
                        <asp:Button ID="btnAddMachine" runat="server" Text="Add Machine Model" OnClick="btnAddMachine_Click" CssClass="btn-primary text-xs py-2 px-4 font-bold cursor-pointer" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Tables: Categories & Machines -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Categories Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-4 border-b border-slate-200 bg-slate-50">
                    <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">Part Categories (<asp:Label ID="lblCatCount" runat="server" Text="0"></asp:Label>)</h2>
                </div>
                <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" CssClass="w-full text-left text-xs border-collapse">
                    <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase p-3" />
                    <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                    <Columns>
                        <asp:BoundField DataField="CategoryId" HeaderText="ID" ItemStyle-CssClass="p-3 font-mono text-slate-500" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category Name" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="p-3 text-slate-500 text-[11px]" />
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Machines Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-4 border-b border-slate-200 bg-slate-50">
                    <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">Compatible Machinery (<asp:Label ID="lblMacCount" runat="server" Text="0"></asp:Label>)</h2>
                </div>
                <asp:GridView ID="gvMachines" runat="server" AutoGenerateColumns="False" CssClass="w-full text-left text-xs border-collapse">
                    <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase p-3" />
                    <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                    <Columns>
                        <asp:BoundField DataField="MachineId" HeaderText="ID" ItemStyle-CssClass="p-3 font-mono text-slate-500" />
                        <asp:BoundField DataField="MachineName" HeaderText="Machine Name" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                        <asp:BoundField DataField="ModelNumber" HeaderText="Model" ItemStyle-CssClass="p-3 font-mono text-slate-600" />
                        <asp:BoundField DataField="Manufacturer" HeaderText="Manufacturer" ItemStyle-CssClass="p-3 text-slate-500" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>

