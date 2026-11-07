<%@ Page Title="Industrial Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.SpareParts.Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Search industrial spare parts across verified stocking suppliers and issue RFQs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Command Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-magnifying-glass mr-1"></i> Global Spares Catalog
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Industrial Spare Parts Catalog
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Locate OEM-compatible industrial components, check machinery compatibility, and issue competitive Requests for Quotation (RFQs).
                </p>
            </div>
            <a href="~/Factory/Quotations/MyRequests.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-list mr-1"></i> View My RFQ Ledger &rarr;
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Search & Filter Controls -->
    <div class="factory-card mb-6">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
            <span class="text-xs font-mono font-bold uppercase text-slate-700">Filter &amp; Query Controls</span>
            <span class="text-xs text-slate-400 font-mono">Matched: <strong id="lblPartsCount" runat="server" class="text-slate-800">0</strong> components</span>
        </div>
        <div class="p-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 text-xs">
                <div>
                    <label class="form-label" for="<%= txtKeyword.ClientID %>">Search Keywords</label>
                    <asp:TextBox ID="txtKeyword" runat="server" placeholder="Part #, keyword, specifications..." CssClass="form-input"></asp:TextBox>
                </div>
                <div>
                    <label class="form-label" for="<%= ddlCategory.ClientID %>">Component Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label class="form-label" for="<%= ddlMachine.ClientID %>">Machine Model Compatibility</label>
                    <asp:DropDownList ID="ddlMachine" runat="server" CssClass="form-select">
                        <asp:ListItem Value="" Text="All Compatible Machinery"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="flex items-end gap-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Apply Filter" OnClick="btnSearch_Click" CssClass="btn-primary flex-1" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary" />
                </div>
            </div>
        </div>
    </div>

    <!-- RFQ Generation Modal / Panel -->
    <asp:Panel ID="pnlRfqModal" runat="server" Visible="false" CssClass="factory-modal-backdrop">
        <div class="factory-modal-dialog">
            <div class="p-4 bg-slate-900 text-white flex justify-between items-center">
                <div>
                    <span class="text-[10px] font-mono uppercase text-sky-400 font-bold block">Issue Commercial Request for Quotation</span>
                    <h3 class="text-sm font-bold m-0 text-white">
                        <asp:Label ID="lblModalPartName" runat="server" Text="Selected Component"></asp:Label>
                    </h3>
                </div>
                <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="text-slate-400 hover:text-white text-lg">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <asp:HiddenField ID="hfSelectedPartId" runat="server" />

            <div class="p-5 space-y-4 text-xs">
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                    <div>
                        <label class="form-label">Required Quantity (Units) <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtModalQuantity" runat="server" TextMode="Number" Text="1" min="1" CssClass="form-input font-bold"></asp:TextBox>
                    </div>
                    <div>
                        <label class="form-label">Target Unit Price (₹)</label>
                        <asp:TextBox ID="txtModalTargetPrice" runat="server" placeholder="Budget limit" CssClass="form-input"></asp:TextBox>
                    </div>
                    <div>
                        <label class="form-label">Required Delivery Date</label>
                        <asp:TextBox ID="txtModalRequiredDate" runat="server" TextMode="Date" CssClass="form-input"></asp:TextBox>
                    </div>
                </div>

                <div>
                    <label class="form-label">Technical Delivery Requirements / Notes</label>
                    <asp:TextBox ID="txtModalRemarks" runat="server" TextMode="MultiLine" Rows="3" placeholder="Specify OEM brand preferences, urgent delivery gate, quality test certificates..." CssClass="form-textarea"></asp:TextBox>
                </div>

                <div class="flex justify-end gap-2.5 pt-3 border-t border-slate-100">
                    <asp:Button ID="btnCancelModal" runat="server" Text="Cancel" OnClick="btnCloseModal_Click" CssClass="btn-secondary" />
                    <asp:Button ID="btnSubmitModalRfq" runat="server" Text="Broadcast RFQ to Suppliers" OnClick="btnSubmitModalRfq_Click" CssClass="btn-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Spare Parts Data Table -->
    <div class="factory-card overflow-hidden">
        <div class="overflow-x-auto">
            <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="False" DataKeyNames="PartId" OnRowCommand="gvParts_RowCommand" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]" />
                    <asp:BoundField DataField="PartName" HeaderText="Component Name" ItemStyle-CssClass="font-bold text-slate-900" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="text-slate-600" />
                    <asp:BoundField DataField="MachineName" HeaderText="Machine Model" ItemStyle-CssClass="text-slate-600 font-medium" NullDisplayText="Universal Machinery" />
                    <asp:BoundField DataField="TechnicalSpecs" HeaderText="Technical Specifications" ItemStyle-CssClass="text-[11px] text-slate-500 max-w-sm truncate" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <asp:Button ID="btnRequestQuote" runat="server" Text="Request Quote" CommandName="RequestQuote" CommandArgument='<%# Eval("PartId") + "|" + Eval("PartName") %>' CssClass="btn-primary text-xs py-1 px-3" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-box-open text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No matching spare parts found.</p>
                        <span class="text-[11px] text-slate-400">Try broadening your keyword search or resetting category filters.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
