<%@ Page Title="Industrial Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Parts.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Parts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/parts.css") %>" rel="stylesheet" />
    <meta name="description" content="Search indexed industrial spare parts by OEM part number, machine model, or category across regional verified suppliers." />
    <script src="<%= ResolveUrl("~/Content/js/ux-utils.js") %>"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- PAGE HEADER -->
    <div style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 48px 0;">
        <div class="sf-container" style="max-width: 960px;">
            <span style="font-size: 12px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 8px;">
                Catalog &amp; Inventory Index
            </span>
            <h1 style="font-size: 28px; color: var(--sf-navy); margin: 0 0 12px 0;">Industrial Spare Parts</h1>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px;">
                Search verified OEM mechanical, hydraulic, and electrical components with cross-referenced machine model compatibility.
            </p>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="sf-container" style="max-width: 960px; padding-top: 32px; padding-bottom: 64px;">
        
        <!-- SEARCH & FILTER -->
        <div class="sf-card" style="margin-bottom: 24px;">
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    
                    <div style="flex: 1; min-width: 260px; position: relative;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 14px; top: 12px; color: var(--sf-text-light); font-size: 14px;"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="sf-input" style="padding-left: 38px;" Placeholder="Search by part name, part # (e.g. 6210-2RS), or model..."></asp:TextBox>
                    </div>

                    <div style="width: 240px; min-width: 200px;">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="sf-input">
                            <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                            <asp:ListItem Value="Hydraulics & Pneumatics" Text="Hydraulics & Pneumatics"></asp:ListItem>
                            <asp:ListItem Value="Motors & Drives" Text="Motors & Drives"></asp:ListItem>
                            <asp:ListItem Value="Bearings & Power Transmission" Text="Bearings & Transmission"></asp:ListItem>
                            <asp:ListItem Value="Electrical & Automation" Text="Electrical & Automation"></asp:ListItem>
                            <asp:ListItem Value="Pumps & Valves" Text="Pumps & Valves"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div style="display: flex; gap: 8px;">
                        <asp:Button ID="btnSearch" runat="server" Text="Filter Parts" OnClick="btnSearch_Click" CssClass="sf-btn sf-btn-primary" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="sf-btn sf-btn-outline" />
                    </div>
                </div>

                <div style="display: flex; align-items: center; gap: 12px; padding-top: 16px; border-top: 1px solid var(--sf-border); flex-wrap: wrap; font-size: 12px;">
                    <span style="font-weight: 600; color: var(--sf-navy);">Quick Filter:</span>
                    <asp:LinkButton ID="btnFilterHydraulics" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Hydraulics & Pneumatics" CssClass="sf-quick-filter">Hydraulics</asp:LinkButton>
                    <asp:LinkButton ID="btnFilterMotors" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Motors & Drives" CssClass="sf-quick-filter">Motors & Drives</asp:LinkButton>
                    <asp:LinkButton ID="btnFilterBearings" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Bearings & Power Transmission" CssClass="sf-quick-filter">Bearings</asp:LinkButton>
                    <asp:LinkButton ID="btnFilterElectrical" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Electrical & Automation" CssClass="sf-quick-filter">Electrical & PLC</asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- RESULTS METADATA -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 12px; color: var(--sf-text-muted);">
            <asp:Label ID="lblResultsCount" runat="server" style="font-weight: 700; color: var(--sf-navy);"></asp:Label>
            <div style="display: flex; align-items: center; gap: 6px;">
                <span style="width: 8px; height: 8px; border-radius: 50%; background: var(--sf-success); display: inline-block;"></span>
                Live Repository Index
            </div>
        </div>

        <!-- PARTS GRID -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <asp:Repeater ID="rptParts" runat="server">
                <ItemTemplate>
                    <div class="sf-card sf-card-hover" style="display: flex; flex-direction: column; justify-content: space-between; padding: 20px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                                <span style="font-size: 11px; font-weight: 700; font-family: monospace; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(23, 105, 224, 0.2);">
                                    <%# Eval("PartNumber") %>
                                </span>
                                <span style='<%# Eval("AvailabilityStatus").ToString() == "InStock" ? "font-size: 11px; font-weight: 700; background: rgba(24, 134, 91, 0.1); color: var(--sf-success); padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(24, 134, 91, 0.2);" : "font-size: 11px; font-weight: 700; background: rgba(180, 83, 9, 0.1); color: var(--sf-warning); padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(180, 83, 9, 0.2);" %>'>
                                    <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "In Stock" : "Limited Stock" %>
                                </span>
                            </div>
                            
                            <h3 style="font-size: 16px; margin: 0 0 4px 0; color: var(--sf-navy); line-height: 1.4;"><%# Eval("PartName") %></h3>
                            <div style="font-size: 12px; color: var(--sf-text-muted); margin-bottom: 16px;"><%# Eval("CategoryName") %></div>
                            
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 24px; font-size: 13px;">
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--sf-text-muted);">Machine Model:</span>
                                    <span style="font-weight: 500;"><%# string.IsNullOrEmpty(Eval("MachineName") as string) ? "Universal" : Eval("MachineName") %></span>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--sf-text-muted);">Estimated Price:</span>
                                    <span style="font-weight: 500;"><%# (Eval("UnitPrice") != null && Eval("UnitPrice") != DBNull.Value) ? "₹" + string.Format("{0:N0}", Eval("UnitPrice")) : "On Request" %></span>
                                </div>
                            </div>
                        </div>

                        <div style="border-top: 1px solid var(--sf-border); margin: 0 -20px; padding: 16px 20px 0;">
                            <!-- Placeholder action, in real system goes to part details/suppliers list -->
                            <a href="~/Public/Suppliers.aspx" runat="server" class="sf-btn sf-btn-outline" style="width: 100%; justify-content: center; font-size: 13px; padding: 8px;">
                                Find Suppliers for this Part
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <!-- EMPTY STATE -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="text-align: center; padding: 64px 0; background: var(--sf-surface); border: 1px dashed var(--sf-border); border-radius: var(--sf-radius-md); margin-top: 24px;">
            <i class="fa-solid fa-box-open" style="font-size: 32px; color: var(--sf-border); margin-bottom: 16px;"></i>
            <h3 style="font-size: 16px; color: var(--sf-navy); margin: 0 0 8px 0;">No matching parts found</h3>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0 0 16px 0;">Try adjusting your search filters or clearing the search query.</p>
            <asp:Button ID="btnResetNoResults" runat="server" Text="Clear Filters" OnClick="btnReset_Click" CssClass="sf-btn sf-btn-outline" />
        </asp:Panel>
        
    </div>
</asp:Content>
