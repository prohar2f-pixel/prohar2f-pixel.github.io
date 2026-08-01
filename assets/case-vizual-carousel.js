(() => {
  const pad = (value) => String(value).padStart(2, '0');

  function initCarousel(root) {
    const track = root.querySelector('[data-carousel-track]');
    const slides = Array.from(root.querySelectorAll('[data-carousel-slide]'));
    const copies = Array.from(root.querySelectorAll('[data-carousel-copy]'));
    const dots = Array.from(root.querySelectorAll('[data-carousel-dot]'));
    const previous = root.querySelector('[data-carousel-prev]');
    const next = root.querySelector('[data-carousel-next]');
    const status = root.querySelector('[data-carousel-status]');
    let index = 0;
    let pointerStart = null;

    if (!track || slides.length === 0 || slides.length !== copies.length) return;

    root.classList.add('is-enhanced');
    slides.forEach((slide) => { slide.hidden = false; });

    const show = (nextIndex, announce = true) => {
      index = (nextIndex + slides.length) % slides.length;
      track.style.setProperty('--cv-carousel-index', index);

      slides.forEach((slide, slideIndex) => {
        const active = slideIndex === index;
        slide.classList.toggle('is-active', active);
        slide.setAttribute('aria-hidden', String(!active));
      });

      copies.forEach((copy, copyIndex) => {
        const active = copyIndex === index;
        copy.hidden = !active;
        copy.classList.toggle('is-active', active);
      });

      dots.forEach((dot, dotIndex) => {
        if (dotIndex === index) dot.setAttribute('aria-current', 'true');
        else dot.removeAttribute('aria-current');
      });

      const label = copies[index].querySelector('h3')?.textContent?.trim() || 'Слайд';
      const count = `${pad(index + 1)} / ${pad(slides.length)}`;
      status.textContent = count;
      if (announce) status.setAttribute('aria-label', `${label}. ${index + 1} из ${slides.length}`);
    };

    previous?.addEventListener('click', () => show(index - 1));
    next?.addEventListener('click', () => show(index + 1));
    dots.forEach((dot, dotIndex) => dot.addEventListener('click', () => show(dotIndex)));

    root.addEventListener('keydown', (event) => {
      if (event.key === 'ArrowLeft') {
        event.preventDefault();
        show(index - 1);
      }
      if (event.key === 'ArrowRight') {
        event.preventDefault();
        show(index + 1);
      }
    });

    root.addEventListener('pointerdown', (event) => {
      pointerStart = { x: event.clientX, y: event.clientY };
    }, { passive: true });

    root.addEventListener('pointerup', (event) => {
      if (!pointerStart) return;
      const deltaX = event.clientX - pointerStart.x;
      const deltaY = event.clientY - pointerStart.y;
      pointerStart = null;
      if (Math.abs(deltaX) < 48 || Math.abs(deltaX) <= Math.abs(deltaY)) return;
      show(index + (deltaX < 0 ? 1 : -1));
    }, { passive: true });

    root.addEventListener('pointercancel', () => { pointerStart = null; }, { passive: true });
    show(0, false);
  }

  document.querySelectorAll('[data-carousel]').forEach(initCarousel);
})();
