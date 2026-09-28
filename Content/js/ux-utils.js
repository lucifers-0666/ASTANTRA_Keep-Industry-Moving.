// Minimal UX utilities: IntersectionObserver trigger, mobile menu toggle
(function(){
  function onReady(fn){ if(document.readyState!='loading') fn(); else document.addEventListener('DOMContentLoaded',fn); }
  onReady(function(){
    // IntersectionObserver for .fade-up and .scale-in
    if('IntersectionObserver' in window){
      var io=new IntersectionObserver(function(entries){
        entries.forEach(function(e){ if(e.isIntersecting){ e.target.classList.add('inview'); io.unobserve(e.target); }} , {threshold:0.12});
      },{root:null,rootMargin:'0px',threshold:0.12});
      document.querySelectorAll('.fade-up, .scale-in').forEach(function(el){ io.observe(el); });
    } else {
      document.querySelectorAll('.fade-up, .scale-in').forEach(function(el){ el.classList.add('inview'); });
    }

    // Mobile drawer
    var toggle=document.getElementById('btnMobileToggle');
    var drawer=document.getElementById('mobileDrawer');
    var backdrop=document.getElementById('mobileDrawerBackdrop');
    if(toggle && drawer){
      toggle.addEventListener('click',function(){
        var open=drawer.classList.toggle('open');
        toggle.setAttribute('aria-expanded',open?'true':'false');
        backdrop.style.display=open?'block':'none';
      });
      backdrop.addEventListener('click',function(){ drawer.classList.remove('open'); backdrop.style.display='none'; toggle.setAttribute('aria-expanded','false'); });
    }
  });
})();
