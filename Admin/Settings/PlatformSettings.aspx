<%@ Page Title="Platform Settings & Governance Configuration" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="PlatformSettings.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Settings.PlatformSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">PLATFORM ADMINISTRATION &amp; CONTROL</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Platform Settings &amp; Governance Rules</h1>
            <p class="text-xs text-[#64748B] m-0">Configure operational thresholds, compliance rules, emergency broadcast radius, and platform outage flags.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-purple-50 text-purple-800 border border-purple-200">
                <i class="fa-solid fa-sliders text-purple-600"></i> LIVE SYSTEM SETTINGS
            </span>
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs admin-animate-enter">
        <div class="flex items-center gap-2.5">
            <i class="fa-solid fa-circle-check text-emerald-600 text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Settings Grid -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-1">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-gear text-[#1769E0]"></i> Platform Configuration Parameters
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Active Variables: <asp:Label ID="lblSettingsCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvSettings" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="SettingKey,SettingValue,Category,Description" 
            OnRowCommand="gvSettings_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No platform configuration parameters found.">
            <Columns>
                <asp:BoundField DataField="Category" HeaderText="Category" HeaderStyle-CssClass="w-32 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-[#1769E0]" />
                
                <asp:TemplateField HeaderText="Parameter Key &amp; Description">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-mono text-xs font-bold text-[#0F172A]"><%# Eval("SettingKey") %></span>
                            <span class="text-[11px] text-[#64748B]"><%# Eval("Description") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Current Operational Value">
                    <ItemTemplate>
                        <span class="font-mono text-xs font-bold bg-slate-100 px-2.5 py-1 rounded border border-slate-300 text-[#0F172A]">
                            <%# Eval("SettingValue") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="UpdatedAt" HeaderText="Last Modified" DataFormatString="{0:dd MMM yyyy HH:mm}" HeaderStyle-CssClass="font-mono" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" />

                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" 
                            CommandName="EditSetting" 
                            CommandArgument='<%# Container.DataItemIndex %>' 
                            CssClass="px-2.5 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                            ToolTip="Modify Setting Value">
                            <i class="fa-solid fa-pen-to-square"></i> Modify
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- EDIT SETTING MODAL -->
    <asp:Panel ID="pnlEditModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-md p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <asp:HiddenField ID="hdnEditSettingKey" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-sliders"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Modify Platform Parameter</h3>
                </div>
                <asp:LinkButton ID="btnCloseEditModal" runat="server" OnClick="btnCloseEditModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3 text-left">
                <div>
                    <label class="form-label text-xs">Parameter Identifier</label>
                    <asp:TextBox ID="txtSettingKeyDisplay" runat="server" ReadOnly="true" CssClass="form-input text-xs py-2 bg-slate-100 font-mono font-bold" />
                </div>

                <div>
                    <label class="form-label text-xs">Description</label>
                    <p class="text-xs text-[#64748B] m-0 bg-slate-50 p-2.5 rounded border border-slate-200" id="lblSettingDesc" runat="server"></p>
                </div>

                <div>
                    <label class="form-label text-xs">New Parameter Value <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtSettingValue" runat="server" CssClass="form-input text-xs py-2 font-mono" />
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCloseEditModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSaveSetting" runat="server" Text="Save Configuration" OnClick="btnSaveSetting_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
