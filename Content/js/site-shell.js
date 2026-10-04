/* ============================================================================
   ASTANTRA INDUSTRIAL PROCUREMENT NETWORK — SHELL INTERACTION SCRIPT
   Robust Fixed-Header, Accessible Mobile Drawer & Microinteractions
   ============================================================================ */

document.addEventListener('DOMContentLoaded', function () {
    var btnMobile = document.getElementById('btnMobileToggle');
    var mobileDrawer = document.getElementById('mobileDrawer');
    var backdrop = document.getElementById('mobileDrawerBackdrop');
    var iconMenu = document.getElementById('iconMenu');
    var headerWrapper = document.getElementById('headerWrapper');

    function openMobileDrawer() {
        if (!mobileDrawer) return;
        mobileDrawer.style.display = 'block';
        if (backdrop) backdrop.style.display = 'block';
        document.body.classList.add('menu-open');
        if (btnMobile) {
            btnMobile.setAttribute('aria-expanded', 'true');
            if (iconMenu) {
                iconMenu.classList.remove('fa-bars');
                iconMenu.classList.add('fa-xmark');
            }
        }
    }

    function closeMobileDrawer() {
        if (!mobileDrawer) return;
        mobileDrawer.style.display = 'none';
        if (backdrop) backdrop.style.display = 'none';
        document.body.classList.remove('menu-open');
        if (btnMobile) {
            btnMobile.setAttribute('aria-expanded', 'false');
            if (iconMenu) {
                iconMenu.classList.remove('fa-xmark');
                iconMenu.classList.add('fa-bars');
            }
        }
    }

    if (btnMobile) {
        btnMobile.setAttribute('aria-expanded', 'false');
        btnMobile.addEventListener('click', function (e) {
            e.stopPropagation();
            if (mobileDrawer && mobileDrawer.style.display === 'block') {
                closeMobileDrawer();
            } else {
                openMobileDrawer();
            }
        });
    }

    if (backdrop) {
        backdrop.addEventListener('click', function () {
            closeMobileDrawer();
        });
    }

    // Close on Escape key press
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && mobileDrawer && mobileDrawer.style.display === 'block') {
            closeMobileDrawer();
            if (btnMobile) btnMobile.focus();
        }
    });

    // Close when clicking any navigation link inside drawer
    if (mobileDrawer) {
        var links = mobileDrawer.querySelectorAll('a');
        links.forEach(function (link) {
            link.addEventListener('click', function () {
                closeMobileDrawer();
            });
        });
    }

    // Auto-close if resized to desktop breakpoint
    window.addEventListener('resize', function () {
        if (window.innerWidth >= 1024 && mobileDrawer && mobileDrawer.style.display === 'block') {
            closeMobileDrawer();
        }
    });

    // Active Navigation Route Synchronizer
    function syncActiveNav() {
        var path = window.location.pathname.toLowerCase();
        var allLinks = document.querySelectorAll('.site-desktop-nav a, .site-mobile-menu a');
        
        allLinks.forEach(function (link) {
            var href = (link.getAttribute('href') || '').toLowerCase();
            var isCurrent = false;

            if (path.indexOf('parts.aspx') !== -1 && href.indexOf('parts.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('suppliers.aspx') !== -1 && href.indexOf('suppliers.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('technicians.aspx') !== -1 && href.indexOf('technicians.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('howitworks.aspx') !== -1 && href.indexOf('howitworks.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('whyus.aspx') !== -1 && href.indexOf('whyus.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('emergency.aspx') !== -1 && href.indexOf('emergency.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('login.aspx') !== -1 && href.indexOf('login.aspx') !== -1) {
                isCurrent = true;
            } else if (path.indexOf('register.aspx') !== -1 && href.indexOf('register.aspx') !== -1) {
                isCurrent = true;
            } else if ((path === '/' || path.indexOf('default.aspx') !== -1) && (href === '/' || href.indexOf('default.aspx') !== -1 || href === 'default.aspx')) {
                isCurrent = true;
            }

            if (isCurrent) {
                link.classList.add('active');
                link.setAttribute('aria-current', 'page');
            }
        });
    }
    syncActiveNav();
});

