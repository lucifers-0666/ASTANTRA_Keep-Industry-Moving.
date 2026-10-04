"""
Script to generate ASTANTRA Brand Assets:
- SVG master vector files (Primary, Compact, Stacked, Symbol, Dark, Monochrome, Favicon)
- Multi-resolution ICO (16x16, 32x32, 48x48)
- High-resolution PNGs (16x16, 32x32, 48x48, 180x180, 192x192, 512x512)
"""

import os
from PIL import Image, ImageDraw, ImageFont

OUTPUT_DIR = r"E:\ASP.NET MCA\Content\images\brand"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ---------------------------------------------------------------------------
# 1. SVG ASSETS
# ---------------------------------------------------------------------------

# Symbol SVG path definition:
# Outer Apex (Cobalt Blue #1769E0):
# Left leg: (50, 6) -> (90, 88) -> (73, 88) -> (50, 41) -> (27, 88) -> (10, 88) -> Z
# Inner Wedge (Charcoal Navy #17212F):
# Top: (36, 68) to (64, 68)
# Bottom: (29, 84) to (71, 84)
# With subtle 2px gap separating wedge from legs.

SVG_SYMBOL_PATHS = """
    <!-- Outer Chevron Apex -->
    <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#1769E0" />
    <!-- Inner Structural Wedge / Crossbar -->
    <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#17212F" />
"""

SVG_SYMBOL_PATHS_DARK = """
    <!-- Outer Chevron Apex -->
    <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#2E7FF4" />
    <!-- Inner Structural Wedge / Crossbar (White on Dark) -->
    <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#FFFFFF" />
"""

SVG_SYMBOL_PATHS_MONO = """
    <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#111827" />
    <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#4B5563" />
"""

# A. logo-symbol.svg (Pure mark)
logo_symbol_svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" aria-label="ASTANTRA Symbol">
{SVG_SYMBOL_PATHS}
</svg>"""

# B. logo-primary.svg (Horizontal Master: Symbol + Wordmark + Tagline)
logo_primary_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 280 44" width="280" height="44" aria-label="ASTANTRA Industrial Procurement Network">
    <defs>
        <style>
            .brand-title { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 20px; font-weight: 900; fill: #17212F; letter-spacing: 0.08em; }
            .brand-tagline { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 7.5px; font-weight: 700; fill: #1769E0; letter-spacing: 0.16em; }
        </style>
    </defs>
    <!-- Symbol scaled to 38x38 at (3, 3) -->
    <g transform="translate(2, 3) scale(0.42)">
        <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#1769E0" />
        <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#17212F" />
    </g>
    <!-- Wordmark & Tagline -->
    <text x="52" y="22" class="brand-title">ASTANTRA</text>
    <text x="53" y="34" class="brand-tagline">KEEP INDUSTRY MOVING</text>
</svg>"""

# C. logo-compact.svg (Horizontal Compact: Symbol + Wordmark)
logo_compact_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 38" width="180" height="38" aria-label="ASTANTRA">
    <defs>
        <style>
            .brand-compact-title { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 19px; font-weight: 900; fill: #17212F; letter-spacing: 0.06em; }
            .brand-compact-sub { font-family: 'IBM Plex Mono', monospace; font-size: 7px; font-weight: 600; fill: #5F6B7A; letter-spacing: 0.14em; }
        </style>
    </defs>
    <g transform="translate(1, 2) scale(0.38)">
        <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#1769E0" />
        <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#17212F" />
    </g>
    <text x="46" y="20" class="brand-compact-title">ASTANTRA</text>
    <text x="47" y="31" class="brand-compact-sub">PROCUREMENT</text>
</svg>"""

# D. logo-stacked.svg (Centered Lockup matching the approved mockup)
logo_stacked_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 360 210" width="360" height="210" aria-label="ASTANTRA Keep Industry Moving">
    <defs>
        <style>
            .stacked-title { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 28px; font-weight: 900; fill: #17212F; letter-spacing: 0.1em; text-anchor: middle; }
            .stacked-tagline { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 12px; font-weight: 700; fill: #1769E0; letter-spacing: 0.18em; text-anchor: middle; }
            .stacked-sub { font-family: 'IBM Plex Sans', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 11px; font-weight: 500; fill: #5F6B7A; letter-spacing: 0.02em; text-anchor: middle; }
        </style>
    </defs>
    <!-- Centered Symbol at X=180, Y=20, scale 0.72 -->
    <g transform="translate(144, 16) scale(0.72)">
        <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#1769E0" />
        <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#17212F" />
    </g>
    <text x="180" y="125" class="stacked-title">ASTANTRA</text>
    <text x="180" y="152" class="stacked-tagline">KEEP INDUSTRY MOVING</text>
    <text x="180" y="178" class="stacked-sub">Industrial Parts &middot; Procurement &middot; Services</text>
</svg>"""

# E. logo-dark.svg (Reversed for dark navy / footer backgrounds)
logo_dark_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 280 44" width="280" height="44" aria-label="ASTANTRA Industrial Procurement Network">
    <defs>
        <style>
            .brand-title-dark { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 20px; font-weight: 900; fill: #FFFFFF; letter-spacing: 0.08em; }
            .brand-tagline-dark { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 7.5px; font-weight: 700; fill: #4D97FF; letter-spacing: 0.16em; }
        </style>
    </defs>
    <g transform="translate(2, 3) scale(0.42)">
        <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#2E7FF4" />
        <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#FFFFFF" />
    </g>
    <text x="52" y="22" class="brand-title-dark">ASTANTRA</text>
    <text x="53" y="34" class="brand-tagline-dark">KEEP INDUSTRY MOVING</text>
</svg>"""

# F. logo-monochrome.svg (Pure 1-color black/white)
logo_monochrome_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 280 44" width="280" height="44" aria-label="ASTANTRA Industrial Procurement Network">
    <defs>
        <style>
            .brand-title-mono { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 20px; font-weight: 900; fill: #111827; letter-spacing: 0.08em; }
            .brand-tagline-mono { font-family: 'Archivo', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 7.5px; font-weight: 700; fill: #4B5563; letter-spacing: 0.16em; }
        </style>
    </defs>
    <g transform="translate(2, 3) scale(0.42)">
        <path d="M 50 6 L 90 88 L 73 88 L 50 41 L 27 88 L 10 88 Z" fill="#111827" />
        <path d="M 37 68 L 63 68 L 69 82 L 31 82 Z" fill="#4B5563" />
    </g>
    <text x="52" y="22" class="brand-title-mono">ASTANTRA</text>
    <text x="53" y="34" class="brand-tagline-mono">KEEP INDUSTRY MOVING</text>
</svg>"""

# G. favicon.svg (Auto-contrast dark/light mode browser tabs)
favicon_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32">
    <style>
        .wedge { fill: #17212F; }
        @media (prefers-color-scheme: dark) {
            .wedge { fill: #FFFFFF; }
        }
    </style>
    <g transform="translate(1, 1) scale(0.30)">
        <path d="M 50 4 L 92 90 L 72 90 L 50 41 L 28 90 L 8 90 Z" fill="#1769E0" />
        <path d="M 36 68 L 64 68 L 70 84 L 30 84 Z" class="wedge" />
    </g>
</svg>"""

# Write all SVG files
with open(os.path.join(OUTPUT_DIR, "logo-symbol.svg"), "w", encoding="utf-8") as f:
    f.write(logo_symbol_svg)
with open(os.path.join(OUTPUT_DIR, "logo-primary.svg"), "w", encoding="utf-8") as f:
    f.write(logo_primary_svg)
with open(os.path.join(OUTPUT_DIR, "logo-compact.svg"), "w", encoding="utf-8") as f:
    f.write(logo_compact_svg)
with open(os.path.join(OUTPUT_DIR, "logo-stacked.svg"), "w", encoding="utf-8") as f:
    f.write(logo_stacked_svg)
with open(os.path.join(OUTPUT_DIR, "logo-dark.svg"), "w", encoding="utf-8") as f:
    f.write(logo_dark_svg)
with open(os.path.join(OUTPUT_DIR, "logo-monochrome.svg"), "w", encoding="utf-8") as f:
    f.write(logo_monochrome_svg)
with open(os.path.join(OUTPUT_DIR, "favicon.svg"), "w", encoding="utf-8") as f:
    f.write(favicon_svg)

print("SVG files generated successfully in", OUTPUT_DIR)

# ---------------------------------------------------------------------------
# 2. RASTER & FAVICON GENERATION USING PILLOW
# ---------------------------------------------------------------------------

def draw_astantra_symbol(size, bg_color=None, dark_wedge=True):
    """Draw high-precision antialiased ASTANTRA symbol at exact pixel dimensions."""
    # Render at 4x supersampling then downscale with LANCZOS for razor-sharp edges
    scale = 4
    canvas_size = size * scale
    img = Image.new("RGBA", (canvas_size, canvas_size), (0, 0, 0, 0) if bg_color is None else bg_color)
    draw = ImageDraw.Draw(img)

    # Coordinates mapped to canvas_size
    # Margin ~ 8%
    m = canvas_size * 0.08
    w = canvas_size - 2 * m
    h = canvas_size - 2 * m

    # Outer chevron points
    apex_x = canvas_size / 2.0
    apex_y = m
    bot_y = canvas_size - m
    
    # Outer leg width
    outer_left_x = m
    outer_right_x = canvas_size - m
    
    # Foot width
    foot_w = w * 0.20
    inner_left_x = outer_left_x + foot_w
    inner_right_x = outer_right_x - foot_w
    
    # Inner apex
    inner_apex_y = m + h * 0.42
    
    chevron_pts = [
        (apex_x, apex_y),
        (outer_right_x, bot_y),
        (inner_right_x, bot_y),
        (apex_x, inner_apex_y),
        (inner_left_x, bot_y),
        (outer_left_x, bot_y)
    ]
    
    blue_color = (23, 105, 224, 255) # #1769E0
    draw.polygon(chevron_pts, fill=blue_color)

    # Inner wedge / crossbar
    wedge_top_y = m + h * 0.70
    wedge_bot_y = m + h * 0.88
    
    # Calculate x positions based on slopes
    # Slope of left inner leg: from (apex_x, inner_apex_y) to (inner_left_x, bot_y)
    dy = bot_y - inner_apex_y
    dx_left = inner_left_x - apex_x
    dx_right = inner_right_x - apex_x
    
    # Inward gap of 3px (supersampled)
    gap = 2.5 * scale
    
    t_ratio_top = (wedge_top_y - inner_apex_y) / dy
    t_ratio_bot = (wedge_bot_y - inner_apex_y) / dy
    
    w_top_left = apex_x + dx_left * t_ratio_top + gap
    w_top_right = apex_x + dx_right * t_ratio_top - gap
    w_bot_left = apex_x + dx_left * t_ratio_bot + gap
    w_bot_right = apex_x + dx_right * t_ratio_bot - gap
    
    wedge_pts = [
        (w_top_left, wedge_top_y),
        (w_top_right, wedge_top_y),
        (w_bot_right, wedge_bot_y),
        (w_bot_left, wedge_bot_y)
    ]
    
    wedge_color = (23, 33, 47, 255) if dark_wedge else (255, 255, 255, 255) # #17212F or White
    draw.polygon(wedge_pts, fill=wedge_color)

    # Downscale with high quality Lanczos antialiasing
    return img.resize((size, size), Image.Resampling.LANCZOS)

# Generate individual PNG icons
icon_16 = draw_astantra_symbol(16)
icon_16.save(os.path.join(OUTPUT_DIR, "favicon-16.png"), format="PNG")

icon_32 = draw_astantra_symbol(32)
icon_32.save(os.path.join(OUTPUT_DIR, "favicon-32.png"), format="PNG")

icon_48 = draw_astantra_symbol(48)
icon_48.save(os.path.join(OUTPUT_DIR, "favicon-48.png"), format="PNG")

icon_180 = draw_astantra_symbol(180, bg_color=(241, 243, 245, 255)) # Apple touch icon on light canvas
icon_180.save(os.path.join(OUTPUT_DIR, "apple-touch-icon.png"), format="PNG")

icon_192 = draw_astantra_symbol(192)
icon_192.save(os.path.join(OUTPUT_DIR, "icon-192.png"), format="PNG")

icon_512 = draw_astantra_symbol(512)
icon_512.save(os.path.join(OUTPUT_DIR, "icon-512.png"), format="PNG")

# Generate Multi-Resolution favicon.ico containing 16x16, 32x32, 48x48
ico_img = Image.new("RGBA", (32, 32))
icon_32.save(
    os.path.join(OUTPUT_DIR, "favicon.ico"),
    format="ICO",
    sizes=[(16, 16), (32, 32), (48, 48)]
)

# Also generate a root /favicon.ico for standard browser fallbacks
icon_32.save(
    r"E:\ASP.NET MCA\favicon.ico",
    format="ICO",
    sizes=[(16, 16), (32, 32), (48, 48)]
)

print("Raster PNGs and Multi-size favicon.ico generated successfully!")
