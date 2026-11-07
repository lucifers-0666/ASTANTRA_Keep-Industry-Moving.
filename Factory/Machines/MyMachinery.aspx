<%@ Page Title="Plant Machinery Fleet" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="MyMachinery.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Machines.MyMachinery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Manage plant machinery, equipment assets, operational status, and maintenance history." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-industry mr-1"></i> Asset Fleet Management
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Plant Machinery &amp; Equipment Fleet
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Register and monitor physical factory machinery, CNC units, presses, and heavy drive assemblies. Associate assets with emergency tickets and maintenance schedules.
                </p>
            </div>
            <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Register Equipment Asset" OnClick="btnOpenAddModal_Click" CssClass="btn-primary text-xs py-2 px-3.5 font-bold" />
        </div>
    </div>

    <!-- Alert Notification -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Metrics Bar -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        <div class="factory-kpi-card">
            <div class="flex items-center justify-between">
                <span class="factory-kpi-label">Registered Fleet</span>
                <i class="fa-solid fa-cubes text-slate-400 text-xs"></i>
            </div>
            <div class="factory-kpi-val" id="lblTotalCount" runat="server">0</div>
            <span class="text-[11px] text-slate-500">Total factory asset tags</span>
        </div>
        <div class="factory-kpi-card border-l-4 border-l-emerald-500">
            <div class="flex items-center justify-between">
                <span class="factory-kpi-label text-emerald-800">Operational</span>
                <i class="fa-solid fa-circle-check text-emerald-500 text-xs"></i>
            </div>
            <div class="factory-kpi-val text-emerald-700" id="lblOperationalCount" runat="server">0</div>
            <span class="text-[11px] text-emerald-600 font-medium">Ready for production</span>
        </div>
        <div class="factory-kpi-card border-l-4 border-l-amber-500">
            <div class="flex items-center justify-between">
                <span class="factory-kpi-label text-amber-800">Maintenance</span>
                <i class="fa-solid fa-screwdriver-wrench text-amber-500 text-xs"></i>
            </div>
            <div class="factory-kpi-val text-amber-600" id="lblMaintenanceCount" runat="server">0</div>
            <span class="text-[11px] text-amber-600 font-medium">Service in progress</span>
        </div>
        <div class="factory-kpi-card border-l-4 border-l-rose-500">
            <div class="flex items-center justify-between">
                <span class="factory-kpi-label text-rose-800">Offline / Stoppage</span>
                <i class="fa-solid fa-triangle-exclamation text-rose-500 text-xs"></i>
            </div>
            <div class="factory-kpi-val text-rose-600" id="lblOfflineCount" runat="server">0</div>
            <span class="text-[11px] text-rose-600 font-medium">Requires attention</span>
        </div>
    </div>

    <!-- Filter & Search Bar -->
    <div class="factory-card p-4 mb-6">
        <div class="flex flex-col sm:flex-row gap-3 items-stretch sm:items-center justify-between">
            <div class="flex flex-1 flex-col sm:flex-row gap-3">
                <div class="relative flex-1">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-slate-400">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input pl-9" placeholder="Search by asset tag, serial number, department or model..."></asp:TextBox>
                </div>
                <div class="w-full sm:w-48">
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                        <asp:ListItem Text="All Statuses" Value="All"></asp:ListItem>
                        <asp:ListItem Text="Operational" Value="Operational"></asp:ListItem>
                        <asp:ListItem Text="Under Maintenance" Value="Under Maintenance"></asp:ListItem>
                        <asp:ListItem Text="Offline" Value="Offline"></asp:ListItem>
                        <asp:ListItem Text="Decommissioned" Value="Decommissioned"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="flex gap-2">
                <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" CssClass="btn-secondary text-xs px-3 py-1.5" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs px-3 py-1.5" />
            </div>
        </div>
    </div>

    <!-- Machinery Data Grid -->
    <div class="factory-card overflow-hidden">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
            <h2 class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 m-0">
                Machinery Register (<strong id="lblGridCount" runat="server" class="text-slate-900">0</strong> Assets)
            </h2>
            <span class="text-[11px] text-slate-400 font-mono">Isolated to your manufacturing plant</span>
        </div>

        <div class="overflow-x-auto">
            <asp:GridView ID="gvMachinery" runat="server" AutoGenerateColumns="False" DataKeyNames="FactoryMachineId" 
                          OnRowCommand="gvMachinery_RowCommand" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Asset Tag" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]">
                        <ItemTemplate>
                            <span class="px-2 py-0.5 rounded bg-blue-50 text-blue-800 border border-blue-200 text-xs font-bold font-mono">
                                <%# Eval("AssetTag") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Machine Specification">
                        <ItemTemplate>
                            <strong class="text-slate-900 block font-medium"><%# Eval("MachineName") %></strong>
                            <span class="text-slate-400 font-mono text-[11px]">Model: <%# Eval("ModelNumber") %> &middot; <%# Eval("Manufacturer") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Department" HeaderText="Department / Bay" ItemStyle-CssClass="font-medium text-slate-800" />
                    <asp:TemplateField HeaderText="Serial Number" ItemStyle-CssClass="font-mono text-slate-700 text-xs">
                        <ItemTemplate>
                            <%# string.IsNullOrEmpty(Eval("SerialNumber") as string) ? "<span class='text-slate-400 font-normal italic'>None</span>" : Eval("SerialNumber") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="InstalledDate" HeaderText="Installed Date" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="font-mono text-slate-700" NullDisplayText="-" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge-status <%# Eval("Status").ToString() == "Operational" ? "badge-delivered" : (Eval("Status").ToString() == "Under Maintenance" ? "badge-processing" : "badge-cancelled") %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Breakdowns" ItemStyle-CssClass="text-center font-mono">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("BreakdownCount")) > 0 
                                ? string.Format("<span class='px-1.5 py-0.5 rounded text-[10px] bg-rose-100 text-rose-700 font-bold border border-rose-200'>{0} SOS</span>", Eval("BreakdownCount")) 
                                : "<span class='text-slate-400 text-xs'>0</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <div class="flex items-center justify-end gap-1.5">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditMachine" CommandArgument='<%# Eval("FactoryMachineId") %>'
                                                CssClass="px-2.5 py-1 text-xs font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded border border-slate-300">
                                    <i class="fa-solid fa-pen-to-square mr-1"></i>Edit
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMachine" CommandArgument='<%# Eval("FactoryMachineId") %>'
                                                OnClientClick="return confirm('Remove this machinery asset from your plant registry?');"
                                                CssClass="px-2.5 py-1 text-xs font-medium text-rose-600 bg-rose-50 hover:bg-rose-100 rounded border border-rose-200">
                                    <i class="fa-solid fa-trash-can mr-1"></i>Delete
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-industry text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No machinery assets registered in this view.</p>
                        <span class="text-[11px] text-slate-400">Register production machines to map spare parts and initiate rapid emergency breakdown triage.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

    <!-- Add / Edit Asset Modal -->
    <asp:Panel ID="pnlMachineModal" runat="server" Visible="false" CssClass="factory-modal-backdrop">
        <div class="factory-modal-dialog">
            <div class="p-4 bg-slate-900 text-white flex justify-between items-center">
                <div>
                    <span class="text-[10px] font-mono uppercase text-sky-400 font-bold block">Plant Equipment Asset Registry</span>
                    <h3 class="text-sm font-bold m-0 text-white">
                        <asp:Label ID="lblModalTitle" runat="server" Text="Register Equipment Asset"></asp:Label>
                    </h3>
                </div>
                <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="text-slate-400 hover:text-white text-lg">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="p-5 space-y-4 text-xs">
                <asp:HiddenField ID="hdnFactoryMachineId" runat="server" Value="0" />

                <div>
                    <label class="form-label" for="<%= ddlMachineModel.ClientID %>">Master Machine Model <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlMachineModel" runat="server" CssClass="form-select font-medium"></asp:DropDownList>
                    <span class="text-[11px] text-slate-400 mt-0.5 block">Select the manufacturer model specification from the master catalog.</span>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label" for="<%= txtAssetTag.ClientID %>">Plant Asset Tag / ID <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAssetTag" runat="server" CssClass="form-input font-mono uppercase font-bold" placeholder="e.g. GHM-CNC-004"></asp:TextBox>
                    </div>
                    <div>
                        <label class="form-label" for="<%= txtSerialNumber.ClientID %>">Serial Number</label>
                        <asp:TextBox ID="txtSerialNumber" runat="server" CssClass="form-input font-mono" placeholder="e.g. SN-884920"></asp:TextBox>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label" for="<%= txtDepartment.ClientID %>">Department / Shop Floor Bay</label>
                        <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-input" placeholder="e.g. CNC Bay #2, Press Shop"></asp:TextBox>
                    </div>
                    <div>
                        <label class="form-label" for="<%= txtInstalledDate.ClientID %>">Installation Date</label>
                        <asp:TextBox ID="txtInstalledDate" runat="server" TextMode="Date" CssClass="form-input"></asp:TextBox>
                    </div>
                </div>

                <div>
                    <label class="form-label" for="<%= ddlStatus.ClientID %>">Operational Status <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Operational (Active on floor)" Value="Operational"></asp:ListItem>
                        <asp:ListItem Text="Under Maintenance (Active service ticket)" Value="Under Maintenance"></asp:ListItem>
                        <asp:ListItem Text="Offline (Awaiting parts / stopped)" Value="Offline"></asp:ListItem>
                        <asp:ListItem Text="Decommissioned (Retired)" Value="Decommissioned"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div>
                    <label class="form-label" for="<%= txtNotes.ClientID %>">Maintenance &amp; Operational Notes</label>
                    <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-textarea" placeholder="Add details on PLC configuration, spindle motor revision, scheduled lubricant intervals..."></asp:TextBox>
                </div>

                <div class="flex justify-end gap-2.5 pt-3 border-t border-slate-100">
                    <asp:Button ID="btnCancelModal" runat="server" Text="Cancel" OnClick="btnCloseModal_Click" CssClass="btn-secondary" />
                    <asp:Button ID="btnSaveMachine" runat="server" Text="Save Asset" OnClick="btnSaveMachine_Click" CssClass="btn-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
