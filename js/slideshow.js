// $(document).on('DOMNodeInserted', '.slider-container', function(e) {
//   showSlides($(e.target), 1);
// });

$(document).ready(function(e) {
$(document).on('DOMNodeInserted', '.slider-container', function(e) {
  showSlides($(e.target), 1);
});

});


$(document).on('click', '.slider-container .next', function(e) {    
    e.preventDefault();
    var item = $(e.target).closest('.slider-container');
    let current = item.attr('data-slider') !== undefined ? parseInt(item.attr('data-slider')) : 1
    showSlides(item, current + 1)
})

$(document).on('click', '.slider-container .back', function(e) {    
    e.preventDefault();
    var item = $(e.target).closest('.slider-container');
    let current = item.attr('data-slider') !== undefined ? parseInt(item.attr('data-slider')) : 1
    showSlides(item, current - 1)
})

$(document).on('mouseover', '.demo.cursor', function(e) {
  e.preventDefault();
  var container = $(e.target).closest('.slider-container');

  var wrapper = $(e.target).closest('.thumbs-wrapper');
  let transform;
  if ($('.row', container)[0].style.transform.match(/-?\d+/)) {
    transform = parseInt($('.row', container)[0].style.transform.match(/-?\d+/)[0]);
  } else {
    transform = 0
  }

  if (e.target.offsetLeft + transform + 100 <= 0) {
    $('.row', container)[0].style.transform =  'translateX('+ (transform + 100).toString() +'px)';
  }
  if (e.target.offsetLeft + 100 + transform > container[0].offsetWidth) {
    $('.row', container)[0].style.transform =  'translateX('+ (transform - 100).toString() +'px)';
  }
})

$(document).on('click', '.demo.cursor', function(e) {    
    e.preventDefault();
    var item = $(e.target).closest('.slider-container');
    var wrapper = $(e.target).closest('.thumbs-wrapper');
        var n = $(e.target).attr('data-showslide');
      console.log(e.target)
      console.log(item)
    showSlides(item, n)
});

function sideScroll(element, direction, speed, distance, step) {
  scrollAmount = 0;
  var slideTimer = setInterval(function() {
    if (direction == 'left') {
      element[0].scrollLeft -= step;
    } else {
      element[0].scrollLeft += step;
    }
    scrollAmount += step;
    if (scrollAmount >= distance) {
      window.clearInterval(slideTimer);
    }
  }, speed);
}


function showSlides(container, n) {
  console.log(container)
  var slideIndex = container.attr('data-slider') !== undefined ? parseInt(container.attr('data-slider')) : 1
  var i;
  var slides = $('.mySlides', container);
  if (slides.length){
    var dots = $('.demo', container);
    var captionText = $('.caption', container);
  
    if (n > slides.length) {slideIndex = 1}
    if (n < 1) {slideIndex = slides.length}
    for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";
    }
    for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
    }
    slides[slideIndex-1].style.display = "block";
    dots[slideIndex-1].className += " active";
    captionText[0].innerHTML = dots[slideIndex-1].alt;
    container.attr('data-slider', n)
  }
}

