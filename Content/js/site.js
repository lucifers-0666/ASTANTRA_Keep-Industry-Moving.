/**
 * ASTANTRA INDUSTRIAL PROCUREMENT NETWORK — CLIENT SCRIPT (site.js)
 * Modern Kit Implementations (M1, M3, M5, M6, M7, M10).
 * Vanilla JavaScript, no frameworks, respects prefers-reduced-motion.
 */
document.addEventListener('DOMContentLoaded', function () {
  'use strict';

  var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // -------------------------------------------------------------------------
  // M1: Command-Style Search (Ctrl+K and "/" hotkeys + chip selection)
  // -------------------------------------------------------------------------
  var searchInput = document.querySelector('.hero-search-input') || document.getElementById('MainContent_txtSearchQuery') || document.querySelector('input[name$="txtSearchQuery"]');

  document.addEventListener('keydown', function (e) {
    // Only trigger if not already typing in another input/textarea
    var activeTag = document.activeElement ? document.activeElement.tagName.toLowerCase() : '';
    if (activeTag === 'input' || activeTag === 'textarea' || activeTag === 'select') return;

    if ((e.ctrlKey && e.key === 'k') || (e.key === '/' && !e.ctrlKey && !e.metaKey)) {
      e.preventDefault();
      if (searchInput) {
        searchInput.focus();
        searchInput.select();
        // Smooth scroll search panel into view if needed
        var panel = document.querySelector('.hero-search-panel');
        if (panel) panel.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }
  });

  // Suggestion Chips Click Handling
  var suggestionChips = document.querySelectorAll('.chip[data-query]');
  suggestionChips.forEach(function (chip) {
    chip.addEventListener('click', function (e) {
      e.preventDefault();
      var q = chip.getAttribute('data-query');
      if (searchInput && q) {
        searchInput.value = q;
        searchInput.focus();
      }

      var bearing = chip.getAttribute('data-bearing');
      if (bearing) {
        updateSchematic(chip);
      }
    });
  });

  // -------------------------------------------------------------------------
  // U1: Update the illustrative bearing drawing from the three sample chips.
  // CSS handles the small transform/opacity transition; reduced motion is CSS.
  // -------------------------------------------------------------------------
  function updateSchematic(chip) {
    var card = document.querySelector('.schematic-card');
    var geometry = document.querySelector('.bearing-geometry');
    var idLabel = document.getElementById('schematic-id-label');
    var odLabel = document.getElementById('schematic-od-label');
    var widthLabel = document.getElementById('schematic-width-label');
    var caption = document.getElementById('schematic-caption');
    var id = chip.getAttribute('data-id');
    var od = chip.getAttribute('data-od');
    var width = chip.getAttribute('data-width');
    var bearing = chip.getAttribute('data-bearing');

    if (!card || !geometry || !idLabel || !odLabel || !widthLabel || !caption) return;

    card.style.setProperty('--bearing-scale', (parseInt(od, 10) / 90).toFixed(2));
    idLabel.textContent = 'ID ø' + id + '.00 mm';
    odLabel.textContent = 'OD ø' + od + '.00 mm';
    widthLabel.textContent = 'B: ' + width + ' mm';
    caption.textContent = 'Illustrative drawing · Open view · Sample 62-series bearing ' + bearing;
    card.classList.add('schematic-is-updated');
  }

  // -------------------------------------------------------------------------
  // M3: Sticky Header Shrinking (72px -> 56px after 40px scroll)
  // -------------------------------------------------------------------------
  var header = document.querySelector('.site-header');
  function handleHeaderScroll() {
    if (!header) return;
    if (window.scrollY > 40) {
      header.classList.add('site-header--shrunk');
    } else {
      header.classList.remove('site-header--shrunk');
    }
  }
  window.addEventListener('scroll', handleHeaderScroll, { passive: true });
  handleHeaderScroll();

  // -------------------------------------------------------------------------
  // M2: Interactive Dimension Callout Highlighting in SVG Schematic
  // -------------------------------------------------------------------------
  var callouts = document.querySelectorAll('[data-dim-target]');
  callouts.forEach(function (item) {
    var targetId = item.getAttribute('data-dim-target');
    var targetEl = document.getElementById(targetId);
    if (!targetEl) return;

    function activate() { targetEl.classList.add('is-active'); }
    function deactivate() { targetEl.classList.remove('is-active'); }

    item.addEventListener('mouseenter', activate);
    item.addEventListener('mouseleave', deactivate);
    item.addEventListener('focus', activate);
    item.addEventListener('blur', deactivate);
  });

  // -------------------------------------------------------------------------
  // M6: Ledger Expandable Rows (Accordion Drawer 0fr -> 1fr)
  // -------------------------------------------------------------------------
  var expandButtons = document.querySelectorAll('.ledger-expand-btn');
  expandButtons.forEach(function (btn) {
    btn.addEventListener('click', function () {
      var isExpanded = btn.getAttribute('aria-expanded') === 'true';
      var drawerId = btn.getAttribute('aria-controls');
      var drawer = document.getElementById(drawerId);

      btn.setAttribute('aria-expanded', !isExpanded);
      var icon = btn.querySelector('i');
      if (icon) {
        icon.className = !isExpanded ? 'fa-solid fa-chevron-up' : 'fa-solid fa-chevron-down';
      }

      if (drawer) {
        if (!isExpanded) {
          drawer.classList.add('is-open');
          drawer.setAttribute('aria-hidden', 'false');
        } else {
          drawer.classList.remove('is-open');
          drawer.setAttribute('aria-hidden', 'true');
        }
      }
    });
  });

  // -------------------------------------------------------------------------
  // U3: Client-side filters apply only to explicitly labeled sample rows.
  // -------------------------------------------------------------------------
  var ledgerFilters = document.querySelectorAll('.ledger-filter');
  var ledgerRows = document.querySelectorAll('.ledger-row');
  var ledgerEmptyState = document.querySelector('.ledger-empty-state');
  ledgerFilters.forEach(function (filterButton) {
    filterButton.addEventListener('click', function () {
      var filter = filterButton.getAttribute('data-filter');
      var visibleRows = 0;

      ledgerFilters.forEach(function (button) {
        var active = button === filterButton;
        button.classList.toggle('is-active', active);
        button.setAttribute('aria-pressed', active ? 'true' : 'false');
      });

      ledgerRows.forEach(function (row) {
        var matches = filter === 'all' || row.getAttribute('data-stock').indexOf(filter) !== -1;
        row.hidden = !matches;
        if (row.nextElementSibling) row.nextElementSibling.hidden = !matches;
        if (matches) visibleRows += 1;
      });

      if (ledgerEmptyState) ledgerEmptyState.hidden = visibleRows !== 0;
    });
  });

  // -------------------------------------------------------------------------
  // M7: Segmented Control (Factories | Suppliers Tabs with Sliding Indicator)
  // -------------------------------------------------------------------------
  var segmentedNav = document.querySelector('.segmented-nav');
  if (segmentedNav) {
    var tabs = segmentedNav.querySelectorAll('.segmented-tab');
    var indicator = segmentedNav.querySelector('.segmented-indicator');
    var panels = document.querySelectorAll('.segmented-panel');

    function updateIndicator(tab) {
      if (!indicator || !tab) return;
      indicator.style.width = tab.offsetWidth + 'px';
      indicator.style.transform = 'translateX(' + tab.offsetLeft + 'px)';
    }

    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        var targetId = tab.getAttribute('aria-controls');

        tabs.forEach(function (t) {
          t.setAttribute('aria-selected', 'false');
          t.setAttribute('tabindex', '-1');
        });
        tab.setAttribute('aria-selected', 'true');
        tab.setAttribute('tabindex', '0');

        panels.forEach(function (panel) {
          if (panel.id === targetId) {
            panel.setAttribute('aria-hidden', 'false');
          } else {
            panel.setAttribute('aria-hidden', 'true');
          }
        });

        updateIndicator(tab);
      });

      // Keyboard navigation (Left/Right arrows)
      tab.addEventListener('keydown', function (e) {
        var tabList = Array.from(tabs);
        var idx = tabList.indexOf(tab);
        var nextTab = null;

        if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
          e.preventDefault();
          nextTab = tabList[(idx + 1) % tabList.length];
        } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
          e.preventDefault();
          nextTab = tabList[(idx - 1 + tabList.length) % tabList.length];
        }

        if (nextTab) {
          nextTab.focus();
          nextTab.click();
        }
      });
    });

    // Initialize indicator position on load
    var activeTab = segmentedNav.querySelector('.segmented-tab[aria-selected="true"]');
    if (activeTab) updateIndicator(activeTab);
    window.addEventListener('resize', function () {
      var current = segmentedNav.querySelector('.segmented-tab[aria-selected="true"]');
      if (current) updateIndicator(current);
    });
  }

  // -------------------------------------------------------------------------
  // M5 & M10: Single IntersectionObserver for Process Rail & Scroll Reveals
  // -------------------------------------------------------------------------
  if (!reducedMotion && 'IntersectionObserver' in window) {
    var observer = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-revealed');
          entry.target.classList.add('is-in-view');
          obs.unobserve(entry.target); // Trigger once only
        }
      });
    }, {
      rootMargin: '0px 0px -40px 0px',
      threshold: 0.12
    });

    // Observe elements with .reveal-on-scroll and the process rail
    var revealTargets = document.querySelectorAll('.reveal-on-scroll, .process-rail-wrap');
    revealTargets.forEach(function (el) {
      observer.observe(el);
    });
  } else {
    // Fallback if reduced-motion or no observer
    document.querySelectorAll('.reveal-on-scroll, .process-rail-wrap').forEach(function (el) {
      el.classList.add('is-revealed', 'is-in-view');
    });
  }
});

