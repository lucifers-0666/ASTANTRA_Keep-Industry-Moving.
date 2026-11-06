<%@ Page Title="Master Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageParts.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.SpareParts.ManageParts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">GLOBAL COMPONENT DIRECTORY</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Master Spare Parts Catalog</h1>
            <p class="text-xs text-[#64748B] m-0">Administer global OEM part numbers, technical specifications, and machine compatibility matrices.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Register New Part" OnClick="btnOpenAddModal_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
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
            <div class="sm:col-span-5 relative">
                <i class="fa-solid fa-magnifying-glass absolute left-3 top-3 text-slate-400 text-xs"></i>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search part number, description, or specs..." CssClass="form-input pl-8 text-xs py-2" />
            </div>

            <!-- Category Filter -->
            <div class="sm:col-span-3">
                <asp:DropDownList ID="ddlFilterCategory" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2">
                    <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Machine Filter -->
            <div class="sm:col-span-2">
                <asp:DropDownList ID="ddlFilterMachine" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2">
                    <asp:ListItem Value="" Text="All Machinery"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Action Buttons -->
            <div class="sm:col-span-2 flex items-center gap-2">
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
                <i class="fa-solid fa-boxes-stacked text-[#EA580C]"></i> Master Component Catalog
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total: <asp:Label ID="lblPartsCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label> components
            </span>
        </div>

        <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="PartId,PartNumber,PartName,TechnicalSpecs,UnitOfMeasure,CategoryName,MachineName" 
            OnRowCommand="gvParts_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No spare parts match the selected catalog filters.">
            <Columns>
                <asp:BoundField DataField="PartId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                
                <asp:TemplateField HeaderText="OEM Part Number">
                    <ItemTemplate>
                        <span class="font-mono font-bold text-xs text-[#1769E0]">
                            <%# Eval("PartNumber") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Component Name">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("PartName") %></span>
                            <span class="text-[10px] text-[#64748B]"><%# Eval("CategoryName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Machine Compatibility">
                    <ItemTemplate>
                        <span class="text-xs text-[#1E293B]">
                            <i class="fa-solid fa-industry text-[10px] text-[#64748B] mr-1"></i><%# Eval("MachineName") != DBNull.Value && !string.IsNullOrEmpty(Eval("MachineName").ToString()) ? Eval("MachineName") : "Universal Industrial" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Technical Specifications">
                    <ItemTemplate>
                        <span class="font-mono text-[11px] text-[#475569] max-w-xs truncate block" title='<%# Eval("TechnicalSpecs") %>'>
                            <%# Eval("TechnicalSpecs") != DBNull.Value && !string.IsNullOrEmpty(Eval("TechnicalSpecs").ToString()) ? Eval("TechnicalSpecs") : "Standard OEM Specs" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="UOM">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            <%# Eval("UnitOfMeasure") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-1.5">
                            <asp:LinkButton ID="btnEdit" runat="server" 
                                CommandName="EditPart" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                ToolTip="Edit Part Specifications">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CommandName="DeletePart" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                OnClientClick="return confirm('WARNING: Are you sure you want to permanently delete this part from the Master Catalog?');" 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                ToolTip="Delete Master Part Record">
                                <i class="fa-solid fa-trash-can"></i>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- MODAL: REGISTER / EDIT MASTER PART SPECIFICATION -->
    <asp:Panel ID="pnlPartModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-xl p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95 max-h-[90vh] overflow-y-auto">
            <asp:HiddenField ID="hdnPartId" runat="server" Value="0" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-orange-50 text-[#EA580C] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0" id="lblPartModalTitle" runat="server">Master Part Record</h3>
                </div>
                <asp:LinkButton ID="btnClosePartModal" runat="server" OnClick="btnClosePartModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">OEM Part Number <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-input text-xs py-2 font-mono font-bold" placeholder="e.g. PART-BRG-005" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Part Component Name <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtPartName" runat="server" CssClass="form-input text-xs py-2" placeholder="e.g. Spherical Roller Bearing" />
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Category Taxonomy <span class="text-rose-500">*</span></label>
                        <asp:DropDownList ID="ddlModalCategory" runat="server" CssClass="form-input text-xs py-2"></asp:DropDownList>
                    </div>
                    <div>
                        <label class="form-label text-xs">Compatible Machinery</label>
                        <asp:DropDownList ID="ddlModalMachine" runat="server" CssClass="form-input text-xs py-2">
                            <asp:ListItem Value="" Text="Universal (Any Industrial Machinery)"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Unit of Measure (UOM)</label>
                    <asp:DropDownList ID="ddlModalUom" runat="server" CssClass="form-input text-xs py-2">
                        <asp:ListItem Value="Piece" Text="Piece (Single Unit)"></asp:ListItem>
                        <asp:ListItem Value="Set" Text="Set (Paired Assembly)"></asp:ListItem>
                        <asp:ListItem Value="Meter" Text="Meter (Length / Cable / Hose)"></asp:ListItem>
                        <asp:ListItem Value="Pack" Text="Pack (Multi-unit Pack)"></asp:ListItem>
                        <asp:ListItem Value="Box" Text="Box"></asp:ListItem>
                        <asp:ListItem Value="Kg" Text="Kg (Weight / Raw Material)"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div>
                    <label class="form-label text-xs">Engineering Specifications &amp; Technical Attributes</label>
                    <asp:TextBox ID="txtSpecs" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-input text-xs py-2 font-mono" placeholder="Inner Dia: 50mm, Outer Dia: 90mm, Width: 20mm, Load: 45kN, IP65" />
                </div>

                <div>
                    <label class="form-label text-xs">Application Scope &amp; Notes</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-input text-xs py-2" placeholder="Used in high-temperature drive shafts..." />
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelPart" runat="server" Text="Cancel" OnClick="btnClosePartModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSavePart" runat="server" Text="Save Part Record" OnClick="btnSavePart_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
