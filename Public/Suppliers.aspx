<%@ Page Title="Industrial Supplier Directory" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Suppliers.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Suppliers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/suppliers.css") %>" rel="stylesheet" />
    <meta name="description" content="Discover and compare verified industrial spare-part suppliers and distributors by location, parts inventory, and response time." />
    <script src="<%= ResolveUrl("~/Content/js/ux-utils.js") %>"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- HEADER -->
    <div style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 48px 0;">
        <div class="sf-container" style="max-width: 960px;">
            <span style="font-size: 12px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 8px;">
                Regional Supplier Directory
            </span>
            <h1 style="font-size: 28px; color: var(--sf-navy); margin: 0 0 12px 0;">Verified Industrial Suppliers</h1>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px;">
                Compare certified spare-part stockists and authorized distributors by geographic location, verified inventory count, and quotation turnaround.
            </p>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="sf-container" style="max-width: 960px; padding-top: 32px; padding-bottom: 64px;">
        
        <!-- SEARCH & FILTER -->
        <div class="sf-card" style="margin-bottom: 24px;">
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                
                <div style="flex: 1; min-width: 260px; position: relative;">
                    <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 14px; top: 12px; color: var(--sf-text-light); font-size: 14px;"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="sf-input" style="padding-left: 38px;" Placeholder="Search by supplier name, city, or specialization..."></asp:TextBox>
                </div>

                <div style="width: 200px;">
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="sf-input">
                        <asp:ListItem Value="" Text="All Locations"></asp:ListItem>
                        <asp:ListItem Value="Ahmedabad" Text="Ahmedabad, GJ"></asp:ListItem>
                        <asp:ListItem Value="Pune" Text="Pune, MH"></asp:ListItem>
                        <asp:ListItem Value="Mumbai" Text="Mumbai, MH"></asp:ListItem>
                        <asp:ListItem Value="Vadodara" Text="Vadodara, GJ"></asp:ListItem>
                        <asp:ListItem Value="Surat" Text="Surat, GJ"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div style="width: 180px;">
                    <asp:DropDownList ID="ddlVerification" runat="server" CssClass="sf-input">
                        <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                        <asp:ListItem Value="Verified" Text="Verified Suppliers"></asp:ListItem>
                        <asp:ListItem Value="Demo" Text="Demo Profiles"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div style="display: flex; gap: 8px;">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="btnSearch_Click" CssClass="sf-btn sf-btn-primary" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="sf-btn sf-btn-outline" />
                </div>
            </div>
        </div>

        <!-- RESULTS METADATA -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 12px; color: var(--sf-text-muted);">
            <asp:Label ID="lblResultsCount" runat="server" style="font-weight: 700; color: var(--sf-navy);"></asp:Label>
            <div style="display: flex; align-items: center; gap: 6px;">
                <span style="width: 8px; height: 8px; border-radius: 50%; background: var(--sf-success); display: inline-block;"></span>
                Regional Stockists Roster
            </div>
        </div>

        <!-- SUPPLIER GRID -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <asp:Repeater ID="rptSuppliers" runat="server">
                <ItemTemplate>
                    <div class="sf-card sf-card-hover" style="display: flex; flex-direction: column; justify-content: space-between; padding: 20px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
                                <div style="display: flex; gap: 12px; align-items: center;">
                                    <div style="width: 40px; height: 40px; border-radius: var(--sf-radius-sm); background: var(--sf-surface-subtle); border: 1px solid var(--sf-border); display: flex; align-items: center; justify-content: center; color: var(--sf-navy);">
                                        <i class="fa-solid fa-warehouse"></i>
                                    </div>
                                    <div>
                                        <h3 style="font-size: 16px; margin: 0 0 4px 0; color: var(--sf-navy); line-height: 1.2;"><%# Eval("CompanyName") %></h3>
                                        <span style="font-size: 12px; color: var(--sf-text-muted); display: flex; align-items: center; gap: 4px;">
                                            <i class="fa-solid fa-location-dot"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                                
                                <span style='<%# Eval("VerificationStatus").ToString() == "Verified" ? "font-size: 11px; font-weight: 700; background: rgba(24, 134, 91, 0.1); color: var(--sf-success); padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(24, 134, 91, 0.2);" : "font-size: 11px; font-weight: 700; background: var(--sf-surface-subtle); color: var(--sf-text-muted); padding: 4px 8px; border-radius: 4px; border: 1px solid var(--sf-border);" %>'>
                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "<i class=\"fa-solid fa-check-circle\"></i> Verified" : "Standard" %>
                                </span>
                            </div>
                            
                            <div style="font-size: 13px; color: var(--sf-text-muted); margin-bottom: 24px; line-height: 1.5;">
                                <%# Eval("Specialization") %>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Rating</div>
                                    <div style="font-size: 14px; font-weight: 600; color: var(--sf-navy);">
                                        <i class="fa-solid fa-star" style="color: #F59E0B; font-size: 12px;"></i> <%# Eval("Rating") %> / 5.0
                                    </div>
                                </div>
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Est. Quotes</div>
                                    <div style="font-size: 14px; font-weight: 600; color: var(--sf-navy);">
                                        2-4 hours
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="border-top: 1px solid var(--sf-border); margin: 0 -20px; padding: 16px 20px 0;">
                            <!-- Action button -->
                            <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-outline" style="width: 100%; justify-content: center; font-size: 13px; padding: 8px;">
                                View Supplier Catalog
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <!-- EMPTY STATE -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="text-align: center; padding: 64px 0; background: var(--sf-surface); border: 1px dashed var(--sf-border); border-radius: var(--sf-radius-md); margin-top: 24px;">
            <i class="fa-solid fa-building-circle-xmark" style="font-size: 32px; color: var(--sf-border); margin-bottom: 16px;"></i>
            <h3 style="font-size: 16px; color: var(--sf-navy); margin: 0 0 8px 0;">No matching suppliers found</h3>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0 0 16px 0;">Try adjusting your location filters or search query.</p>
            <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="sf-btn sf-btn-outline" />
        </asp:Panel>
        
    </div>
</asp:Content>
