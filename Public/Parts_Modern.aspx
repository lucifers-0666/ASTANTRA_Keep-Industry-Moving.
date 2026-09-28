<%@ Page Title="Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Parts.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Parts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Browse our comprehensive catalog of industrial spare parts with fast delivery and competitive pricing." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HERO SECTION -->
    <div class="hero hero--minimal l-section--no-padding">
        <div class="container">
            <h6 style="margin-bottom: var(--space-2); color: var(--color-brand-primary);">
                <i class="fa-solid fa-boxes-stacked"></i> Inventory Management
            </h6>
            <h1 style="margin-bottom: var(--space-4); font-size: var(--text-4xl);">Premium Spare Parts Catalog</h1>
            <p style="font-size: var(--text-lg); color: var(--color-text-secondary); line-height: var(--leading-relaxed); margin-bottom: 0;">
                Discover verified OEM and aftermarket parts. Real-time availability, competitive pricing, and logistics coordination.
            </p>
        </div>
    </div>

    <!-- FILTERS & SEARCH -->
    <div class="l-section">
        <div class="container">
            <div class="card" style="margin-bottom: var(--space-6);">
                <div style="display: flex; flex-wrap: wrap; gap: var(--space-3); align-items: flex-end;">
                    <div style="flex: 1; min-width: 250px; position: relative;">
                        <label class="form-label">Part Name or Model</label>
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: var(--space-3); bottom: var(--space-2); color: var(--color-text-muted);"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search parts..." 
                            style="padding-left: 36px;" />
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label class="form-label">Category</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                            <asp:ListItem Value="" Text="All Categories" />
                            <asp:ListItem Value="Bearings" Text="Bearings & Bushings" />
                            <asp:ListItem Value="Seals" Text="Seals & Gaskets" />
                            <asp:ListItem Value="Motors" Text="Motors & Drives" />
                            <asp:ListItem Value="Pumps" Text="Pumps & Valves" />
                        </asp:DropDownList>
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label class="form-label">In Stock</label>
                        <asp:DropDownList ID="ddlStock" runat="server" CssClass="form-control">
                            <asp:ListItem Value="" Text="Any Availability" />
                            <asp:ListItem Value="Available" Text="In Stock" />
                            <asp:ListItem Value="Ordered" Text="Pre-Order" />
                        </asp:DropDownList>
                    </div>
                    <div style="display: flex; gap: var(--space-2);">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="btn btn-primary" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn btn-secondary" />
                    </div>
                </div>
            </div>

            <!-- RESULTS GRID -->
            <div class="card-gallery">
                <asp:Repeater ID="rptParts" runat="server">
                    <ItemTemplate>
                        <div class="gallery-card">
                            <div class="gallery-card-image">
                                <img src='<%= ResolveUrl("~/Content/images/") %>placeholder.jpg' alt="<%# Eval("PartName") %>" />
                            </div>
                            <div class="gallery-card-content">
                                <h4 class="gallery-card-title"><%# Eval("PartName") %></h4>
                                <p class="gallery-card-text">
                                    Model: <strong><%# Eval("ModelNumber") %></strong><br />
                                    Category: <%# Eval("Category") %>
                                </p>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span class="badge badge-success">In Stock: <%# Eval("Quantity") %></span>
                                    <span class="badge badge-info"><%# Eval("DeliveryDays") %> days</span>
                                </div>
                            </div>
                            <div class="gallery-card-footer">
                                <span class="gallery-card-price">₹<%# Eval("Price", "{0:N0}") %></span>
                                <button class="btn btn-primary btn-sm">Add to Cart</button>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Empty State -->
            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div style="text-align: center; padding: var(--space-12); background: var(--color-bg-subtle); border-radius: var(--radius-lg);">
                    <i class="fa-solid fa-inbox" style="font-size: var(--text-5xl); color: var(--color-text-muted); margin-bottom: var(--space-3);"></i>
                    <h3 style="color: var(--color-text-primary); margin-bottom: var(--space-2);">No parts found</h3>
                    <p style="color: var(--color-text-secondary);">Try different search criteria</p>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

</asp:Content>
