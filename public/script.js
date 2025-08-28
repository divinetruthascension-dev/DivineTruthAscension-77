document.addEventListener('DOMContentLoaded', () => {
  const contentDiv = document.getElementById('dta-content');
  const navLinks = document.querySelectorAll('.dta-nav a');

  // Handle nav clicks for dynamic loading
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault(); // prevent full page reload
      const page = link.getAttribute('data-page');

      fetch(page)
        .then(response => response.text())
        .then(html => {
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const newContent = doc.getElementById('dta-content');
          if (newContent) {
            contentDiv.innerHTML = newContent.innerHTML;
            // Highlight current nav link
            navLinks.forEach(l => l.style.textDecoration = "none");
            link.style.textDecoration = "underline";
            link.style.color = "#000000";
            // Update browser history
            window.history.pushState({ page: page }, '', page);
          }
        })
        .catch(() => {
          contentDiv.innerHTML = "<h2>Offline or page not found</h2>";
        });
    });
  });

  // Handle back/forward buttons
  window.addEventListener('popstate', (event) => {
    if (event.state && event.state.page) {
      fetch(event.state.page)
        .then(resp => resp.text())
        .then(html => {
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const bodyContent = doc.getElementById('dta-content');
          if(bodyContent) contentDiv.innerHTML = bodyContent.innerHTML;
        });
    }
  });
});document.addEventListener('DOMContentLoaded', () => {
  const contentDiv = document.getElementById('dta-content');
  const navLinks = document.querySelectorAll('.dta-nav a');

  // Handle nav clicks for dynamic loading
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault(); // prevent full page reload
      const page = link.getAttribute('data-page');

      fetch(page)
        .then(response => response.text())
        .then(html => {
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const newContent = doc.getElementById('dta-content');
          if (newContent) {
            contentDiv.innerHTML = newContent.innerHTML;
            // Highlight current nav link
            navLinks.forEach(l => l.style.textDecoration = "none");
            link.style.textDecoration = "underline";
            link.style.color = "#000000";
            // Update browser history
            window.history.pushState({ page: page }, '', page);
          }
        })
        .catch(() => {
          contentDiv.innerHTML = "<h2>Offline or page not found</h2>";
        });
    });
  });

  // Handle back/forward buttons
  window.addEventListener('popstate', (event) => {
    if (event.state && event.state.page) {
      fetch(event.state.page)
        .then(resp => resp.text())
        .then(html => {
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const bodyContent = doc.getElementById('dta-content');
          if(bodyContent) contentDiv.innerHTML = bodyContent.innerHTML;
        });
    }
  });
});
