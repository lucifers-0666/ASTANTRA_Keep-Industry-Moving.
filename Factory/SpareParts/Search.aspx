<%@ Page Title="Spare Parts Search" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.SpareParts.Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Search industrial spare parts across verified stocking suppliers and issue RFQs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">
                    <i class="fa-solid fa-magnifying-glass mr-1"></i> MASTER INVENTORY BROWSER
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Industrial Spare Parts Catalog
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Locate compatible OEM spare parts across verified regional suppliers and generate structured quotation requests.
                </p>
            </div>
            <a href="~/Factory/Quotations/MyRequests.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-list mr-1"></i> View My RFQ Requests
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Search & Filter Bar -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-4 mb-6 shadow-xs">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
            <div>
                <label class="block text-[11px] font-bold text-[#5F6B7A] uppercase mb-1">Search Keywords</label>
                <asp:TextBox ID="txtKeyword" runat="server" placeholder="Part #, keyword, or specs..." CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px] focus:outline-none focus:border-[#1769E0]"></asp:TextBox>
            </div>
            <div>
                <label class="block text-[11px] font-bold text-[#5F6B7A] uppercase mb-1">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px] focus:outline-none focus:border-[#1769E0]">
                    <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-[11px] font-bold text-[#5F6B7A] uppercase mb-1">Machine Model</label>
                <asp:DropDownList ID="ddlMachine" runat="server" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px] focus:outline-none focus:border-[#1769E0]">
                    <asp:ListItem Value="" Text="All Compatible Machines"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="flex items-end gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Apply Filter" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2 px-4 font-bold flex-1 cursor-pointer" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-3 font-bold cursor-pointer" />
            </div>
        </div>
    </div>

    <!-- RFQ Generation Drawer / Panel -->
    <asp:Panel ID="pnlRfqModal" runat="server" Visible="false" CssClass="bg-[#F8FAFC] border-2 border-[#1769E0] rounded-[3px] p-6 mb-6 shadow-md">
        <div class="flex justify-between items-center mb-4 pb-3 border-b border-[#D5DCE3]">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1 inline-block">STRUCTURED COMMERCIAL RFQ</span>
                <h3 class="text-base font-bold text-[#17212F] m-0">
                    Issue Quotation Request: <asp:Label ID="lblModalPartName" runat="server" CssClass="text-[#1769E0]"></asp:Label>
                </h3>
            </div>
            <asp:Button ID="btnCloseModal" runat="server" Text="✕ Close" OnClick="btnCloseModal_Click" CssClass="text-xs text-[#5F6B7A] hover:text-[#17212F] bg-transparent border-0 cursor-pointer font-bold" />
        </div>

        <asp:HiddenField ID="hfSelectedPartId" runat="server" />

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Required Quantity <span class="text-red-500">*</span></label>
                <asp:TextBox ID="txtModalQuantity" runat="server" TextMode="Number" Text="1" min="1" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Target Unit Price (₹)</label>
                <asp:TextBox ID="txtModalTargetPrice" runat="server" placeholder="Optional budget limit" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Required By Date</label>
                <asp:TextBox ID="txtModalRequiredDate" runat="server" TextMode="Date" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
            </div>
        </div>

        <div class="mb-4">
            <label class="block text-xs font-bold text-[#17212F] mb-1">Technical Delivery Requirements / Notes</label>
            <asp:TextBox ID="txtModalRemarks" runat="server" TextMode="MultiLine" Rows="2" placeholder="Specify OEM brand preferences, urgent delivery location, or test certificates..." CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
        </div>

        <div class="flex justify-end gap-3">
            <asp:Button ID="btnCancelModal" runat="server" Text="Cancel" OnClick="btnCloseModal_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
            <asp:Button ID="btnSubmitModalRfq" runat="server" Text="Transmit RFQ to Regional Suppliers" OnClick="btnSubmitModalRfq_Click" CssClass="btn-primary text-xs py-2 px-5 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- Spare Parts Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden">
        <div class="p-4 border-b border-[#D5DCE3] flex justify-between items-center bg-[#FAFAFA]">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Verified Industrial Parts Directory (<asp:Label ID="lblPartsCount" runat="server" Text="0"></asp:Label> items)
            </h2>
            <span class="text-[11px] text-[#5F6B7A]">Click "Request Quote" to issue an RFQ</span>
        </div>

        <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="False" DataKeyNames="PartId" OnRowCommand="gvParts_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]" />
                <asp:BoundField DataField="PartName" HeaderText="Part Name" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="p-3 text-[#5F6B7A]" />
                <asp:BoundField DataField="MachineName" HeaderText="Machine Compatibility" ItemStyle-CssClass="p-3 text-[#5F6B7A]" NullDisplayText="Universal" />
                <asp:BoundField DataField="TechnicalSpecs" HeaderText="Specifications" ItemStyle-CssClass="p-3 text-[11px] text-[#5F6B7A] max-w-xs truncate" />
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="p-3 text-right">
                    <ItemTemplate>
                        <asp:Button ID="btnRequestQuote" runat="server" Text="Request Quote" CommandName="RequestQuote" CommandArgument='<%# Eval("PartId") + "|" + Eval("PartName") %>' CssClass="btn-primary text-[11px] py-1.5 px-3 font-bold cursor-pointer" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-box-open text-2xl text-[#94A3B8] mb-2 block"></i>
                    <p class="text-xs font-semibold m-0">No matching spare parts found.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0 mt-1">Try broadening your keyword search or resetting category filters.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

