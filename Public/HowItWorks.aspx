<%@ Page Title="How SPAREFINDER Works" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HowItWorks.aspx.cs" Inherits="IndustrialSparePartPortal.Public.HowItWorks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/how-it-works.css") %>" rel="stylesheet" />
    <meta name="description" content="Understand the B2B industrial procurement workflow on SPAREFINDER, from RFQ to dispatch." />
    <script src="<%= ResolveUrl("~/Content/js/ux-utils.js") %>"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 48px 0;">
        <div class="sf-container" style="max-width: 960px;">
            <span style="font-size: 12px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 8px;">
                Platform Workflow
            </span>
            <h1 style="font-size: 28px; color: var(--sf-navy); margin: 0 0 12px 0;">How SPAREFINDER Works</h1>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px;">
                A centralized, transparent workflow designed specifically for industrial B2B spare-part procurement and emergency technical support.
            </p>
        </div>
    </div>

    <div class="sf-container" style="max-width: 960px; padding-top: 64px; padding-bottom: 64px;">
        <div style="display: flex; flex-direction: column; gap: 48px; position: relative;">
            
            <div style="display: flex; gap: 32px; align-items: flex-start; flex-direction: column; border-bottom: 1px solid var(--sf-border); padding-bottom: 32px;" class="md:flex-row">
                <div style="font-size: 64px; font-weight: 800; color: var(--sf-surface-subtle); line-height: 1; margin-top: -8px;">01</div>
                <div>
                    <h2 style="font-size: 20px; color: var(--sf-navy); margin: 0 0 12px 0;">Identify &amp; Search</h2>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px; line-height: 1.6;">
                        Factory procurement teams search the indexed catalog using OEM part numbers, descriptions, or specific machine models. The system cross-references availability across all verified regional suppliers.
                    </p>
                </div>
            </div>

            <div style="display: flex; gap: 32px; align-items: flex-start; flex-direction: column; border-bottom: 1px solid var(--sf-border); padding-bottom: 32px;" class="md:flex-row">
                <div style="font-size: 64px; font-weight: 800; color: var(--sf-surface-subtle); line-height: 1; margin-top: -8px;">02</div>
                <div>
                    <h2 style="font-size: 20px; color: var(--sf-navy); margin: 0 0 12px 0;">Compare Quotations</h2>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px; line-height: 1.6;">
                        Suppliers instantly provide pricing, lead times, and warranty terms. Buyers compare quotations side-by-side in their secure dashboard, factoring in the supplier's verified rating and geographic distance.
                    </p>
                </div>
            </div>

            <div style="display: flex; gap: 32px; align-items: flex-start; flex-direction: column; border-bottom: 1px solid var(--sf-border); padding-bottom: 32px;" class="md:flex-row">
                <div style="font-size: 64px; font-weight: 800; color: var(--sf-surface-subtle); line-height: 1; margin-top: -8px;">03</div>
                <div>
                    <h2 style="font-size: 20px; color: var(--sf-navy); margin: 0 0 12px 0;">Procure &amp; Dispatch</h2>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px; line-height: 1.6;">
                        Upon selection, a formal procurement order is generated. If installation assistance or troubleshooting is required, an independent, certified field technician can be booked concurrently.
                    </p>
                </div>
            </div>

            <div style="display: flex; gap: 32px; align-items: flex-start; flex-direction: column;" class="md:flex-row">
                <div style="font-size: 64px; font-weight: 800; color: var(--sf-surface-subtle); line-height: 1; margin-top: -8px;">04</div>
                <div>
                    <h2 style="font-size: 20px; color: var(--sf-navy); margin: 0 0 12px 0;">Emergency Protocol</h2>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px; line-height: 1.6;">
                        For critical plant downtime, the Emergency Desk bypasses standard search. It blasts an immediate priority alert to all regional stockists and available on-call engineers to resolve the breakdown in hours, not days.
                    </p>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
