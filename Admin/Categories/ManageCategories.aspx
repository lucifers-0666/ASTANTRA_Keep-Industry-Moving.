<%@ Page Title="Categories & Industrial Machinery" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCategories.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Categories.ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">TAXONOMY &amp; MACHINERY SPECIFICATION</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Part Categories &amp; Machine Models</h1>
            <p class="text-xs text-[#64748B] m-0">Define industrial component taxonomies, classification families, and compatible machine models.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnOpenAddCategoryModal" runat="server" Text="+ New Category" OnClick="btnOpenAddCategoryModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
            <asp:Button ID="btnOpenAddMachineModal" runat="server" Text="+ New Machine" OnClick="btnOpenAddMachineModal_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
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

    <!-- Two-Pane High Density Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 admin-animate-enter admin-stagger-1">
        <!-- PANE 1: COMPONENT CATEGORIES -->
        <div class="table-container shadow-xs">
            <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-diagram-project text-[#7C3AED]"></i>
                    <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">Part Categories</h2>
                </div>
                <span class="text-xs font-mono font-bold text-[#64748B]">
                    Total: <asp:Label ID="lblCatCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
                </span>
            </div>

            <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="CategoryId,CategoryName,Description,IconClass" 
                OnRowCommand="gvCategories_RowCommand" 
                CssClass="table-custom" GridLines="None" 
                EmptyDataText="No component categories configured.">
                <Columns>
                    <asp:BoundField DataField="CategoryId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                    
                    <asp:TemplateField HeaderText="Category Name &amp; Icon">
                        <ItemTemplate>
                            <div class="flex items-center gap-2.5">
                                <div class="w-6 h-6 rounded bg-purple-50 text-purple-700 flex items-center justify-center text-xs shrink-0 border border-purple-200">
                                    <i class='<%# Eval("IconClass") != DBNull.Value && !string.IsNullOrEmpty(Eval("IconClass").ToString()) ? Eval("IconClass") : "fa-solid fa-cogs" %>'></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-bold text-xs text-[#0F172A]"><%# Eval("CategoryName") %></span>
                                    <span class="text-[10px] text-[#64748B] truncate max-w-[200px]"><%# Eval("Description") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <div class="flex items-center justify-end gap-1.5">
                                <asp:LinkButton ID="btnEditCat" runat="server" 
                                    CommandName="EditCategory" 
                                    CommandArgument='<%# Container.DataItemIndex %>' 
                                    CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                    ToolTip="Edit Category">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelCat" runat="server" 
                                    CommandName="DeleteCategory" 
                                    CommandArgument='<%# Container.DataItemIndex %>' 
                                    OnClientClick="return confirm('Delete this category? (Will be rejected if parts are attached)');" 
                                    CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                    ToolTip="Delete Category">
                                    <i class="fa-solid fa-trash-can"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- PANE 2: INDUSTRIAL MACHINERY -->
        <div class="table-container shadow-xs">
            <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-industry text-[#1769E0]"></i>
                    <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">Compatible Machinery Models</h2>
                </div>
                <span class="text-xs font-mono font-bold text-[#64748B]">
                    Total: <asp:Label ID="lblMacCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
                </span>
            </div>

            <asp:GridView ID="gvMachines" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="MachineId,MachineName,ModelNumber,Manufacturer" 
                OnRowCommand="gvMachines_RowCommand" 
                CssClass="table-custom" GridLines="None" 
                EmptyDataText="No industrial machine models configured.">
                <Columns>
                    <asp:BoundField DataField="MachineId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                    
                    <asp:TemplateField HeaderText="Machine Model">
                        <ItemTemplate>
                            <div class="flex flex-col">
                                <span class="font-bold text-xs text-[#0F172A]"><%# Eval("MachineName") %></span>
                                <span class="text-[10px] text-[#64748B] font-mono">Model: <%# Eval("ModelNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("ModelNumber").ToString()) ? Eval("ModelNumber") : "Universal" %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Manufacturer" HeaderText="Manufacturer" ItemStyle-CssClass="text-xs text-[#1E293B]" NullDisplayText="Universal" />

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <div class="flex items-center justify-end gap-1.5">
                                <asp:LinkButton ID="btnEditMac" runat="server" 
                                    CommandName="EditMachine" 
                                    CommandArgument='<%# Container.DataItemIndex %>' 
                                    CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                    ToolTip="Edit Machine Model">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelMac" runat="server" 
                                    CommandName="DeleteMachine" 
                                    CommandArgument='<%# Container.DataItemIndex %>' 
                                    OnClientClick="return confirm('Delete this machine model? (Will be rejected if parts are attached)');" 
                                    CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                    ToolTip="Delete Machine Model">
                                    <i class="fa-solid fa-trash-can"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- MODAL 1: ADD / EDIT CATEGORY -->
    <asp:Panel ID="pnlCategoryModal" runat="server" Visible="false" CssClass="admin-modal-overlay">
        <div class="admin-modal-dialog surface-card w-full max-w-md shadow-2xl">
            <asp:HiddenField ID="hdnCategoryId" runat="server" Value="0" />

            <div class="admin-modal-header border-b border-[#E2E8F0]">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded bg-purple-50 text-purple-700 flex items-center justify-center text-xs shadow-xs border border-purple-200">
                        <i class="fa-solid fa-folder-plus"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0" id="lblCatModalTitle" runat="server">Category Record</h3>
                        <span class="text-[10px] font-mono text-[#64748B] block mt-0.5">SPARE-PART TAXONOMY &amp; HIERARCHY</span>
                    </div>
                </div>
                <asp:LinkButton ID="btnCloseCatModal" runat="server" OnClick="btnCloseCatModal_Click" CssClass="admin-modal-close-btn" ToolTip="Close dialog">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="admin-modal-body space-y-3">
                <div>
                    <label class="form-label text-xs">Category Classification Name <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-input text-xs" placeholder="e.g. Bearings & Power Transmission" />
                </div>

                <div>
                    <label class="form-label text-xs">Scope Description</label>
                    <asp:TextBox ID="txtCategoryDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-input text-xs" placeholder="Brief description of parts included..." />
                </div>

                <div>
                    <label class="form-label text-xs">FontAwesome Icon Class</label>
                    <asp:TextBox ID="txtCategoryIcon" runat="server" CssClass="form-input text-xs font-mono" placeholder="fa-solid fa-gear" />
                    <span class="admin-form-hint">e.g. fa-solid fa-gear, fa-solid fa-bolt, fa-solid fa-wrench</span>
                </div>
            </div>

            <div class="admin-modal-footer border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelCat" runat="server" Text="Cancel" OnClick="btnCloseCatModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSaveCategory" runat="server" Text="Save Category" OnClick="btnSaveCategory_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>

    <!-- MODAL 2: ADD / EDIT MACHINE -->
    <asp:Panel ID="pnlMachineModal" runat="server" Visible="false" CssClass="admin-modal-overlay">
        <div class="admin-modal-dialog surface-card w-full max-w-md shadow-2xl">
            <asp:HiddenField ID="hdnMachineId" runat="server" Value="0" />

            <div class="admin-modal-header border-b border-[#E2E8F0]">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs shadow-xs border border-blue-200">
                        <i class="fa-solid fa-industry"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0" id="lblMacModalTitle" runat="server">Industrial Machine Profile</h3>
                        <span class="text-[10px] font-mono text-[#64748B] block mt-0.5">COMPATIBLE MACHINERY ASSET PROFILE</span>
                    </div>
                </div>
                <asp:LinkButton ID="btnCloseMacModal" runat="server" OnClick="btnCloseMacModal_Click" CssClass="admin-modal-close-btn" ToolTip="Close dialog">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="admin-modal-body space-y-3">
                <div>
                    <label class="form-label text-xs">Industrial Machine Name <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtMachineName" runat="server" CssClass="form-input text-xs" placeholder="e.g. CNC Lathe Machine X200" />
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Model Number</label>
                        <asp:TextBox ID="txtMachineModel" runat="server" CssClass="form-input text-xs font-mono" placeholder="X200-PRO" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Manufacturer</label>
                        <asp:TextBox ID="txtMachineMfg" runat="server" CssClass="form-input text-xs" placeholder="Siemens / DMG Mori" />
                    </div>
                </div>
            </div>

            <div class="admin-modal-footer border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelMac" runat="server" Text="Cancel" OnClick="btnCloseMacModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSaveMachine" runat="server" Text="Save Machine Model" OnClick="btnSaveMachine_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
