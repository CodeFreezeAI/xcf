// XCF.ai Website JavaScript

// Wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80, // Account for fixed header
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Active link highlighting in documentation sidebar
    const docSections = document.querySelectorAll('.docs-section');
    const sidebarLinks = document.querySelectorAll('.docs-sidebar a');
    
    if (docSections.length && sidebarLinks.length) {
        // Add scroll event listener for documentation section
        window.addEventListener('scroll', function() {
            let currentSection = '';
            
            docSections.forEach(section => {
                const sectionTop = section.offsetTop - 100;
                if (pageYOffset >= sectionTop) {
                    currentSection = '#' + section.getAttribute('id');
                }
            });
            
            sidebarLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === currentSection) {
                    link.classList.add('active');
                }
            });
        });
    }
    
    // Simple testimonial slider navigation
    const testimonialSlider = document.querySelector('.testimonial-slider');
    const testimonials = document.querySelectorAll('.testimonial');
    
    if (testimonialSlider && testimonials.length > 1) {
        let currentIndex = 0;
        
        // Auto-slide every 5 seconds
        setInterval(() => {
            currentIndex = (currentIndex + 1) % testimonials.length;
            const offset = testimonials[0].offsetWidth * currentIndex;
            testimonialSlider.scrollTo({
                left: offset,
                behavior: 'smooth'
            });
        }, 5000);
    }
    
    // Mobile navigation toggle (if we add it later)
    const mobileNavToggle = document.querySelector('.mobile-nav-toggle');
    const navigation = document.querySelector('nav ul');
    
    if (mobileNavToggle && navigation) {
        mobileNavToggle.addEventListener('click', function() {
            navigation.classList.toggle('active');
            this.setAttribute('aria-expanded', 
                this.getAttribute('aria-expanded') === 'true' ? 'false' : 'true'
            );
        });
    }
    
    // NOTE: Removed the code that adds copy buttons to code blocks
    // This functionality is now handled directly in the HTML with inline scripts
    
    // Create directory for images if they don't exist (placeholder)
    console.log('XCF.ai website loaded successfully');
}); 