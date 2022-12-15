$(document).on('click', '.slider-container .slider-next', function(e) {
    e.preventDefault();
    var item = $(e.target).closest('.slider-container');
    let current = item.attr('data-slider') !== undefined ? parseInt(item.attr('data-slider')) : 1
    showSlides(item, current + 1)
})

$(document).on('click', '.slider-container .slider-prev', function(e) {
    e.preventDefault();
    var item = $(e.target).closest('.slider-container');
    let current = item.attr('data-slider') !== undefined ? parseInt(item.attr('data-slider')) : 1
    showSlides(item, current - 1)
})

$(document).on('click', '.demo.cursor', function(e) {
    e.preventDefault();
    e.stopPropagation();
    var item = $(e.target).closest('.slider-container');
    var wrapper = $(e.target).closest('.thumbs-wrapper');
    var n = $(e.target).attr('data-showslide');
    showSlides(item, parseInt(n))
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
  var slideIndex = n-1//container.attr('data-slider') !== undefined ? parseInt(container.attr('data-slider')) : 1
  var i;
  var slides = $('.mySlides', container);
  if (slides.length > 0) {
    var dots = $('.demo', container);
    var captionText = $('.caption', container);
    if (n > slides.length) {slideIndex = 0}
    if (n < 1) {slideIndex = slides.length}

    for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";
    }
    for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
    }
    console.log(slides[slideIndex], slideIndex)
    slides[slideIndex].style.display = "flex";
    dots[slideIndex].className += " active";
    captionText[0].innerHTML = dots[slideIndex].alt;
    container.attr('data-slider', n)
  }
}


$(document).ready(function(e) {
  $(document).on('DOMNodeInserted', ".content-panel .grid-wrap", function(event) {
    $('.slider-container', event.target).each(function(_i, i) {
      showSlides($(i), 1);
    })

    $('.mySlides img', event.target).each((_i, i) => {
      i.onload = function(){
          if (this.naturalWidth > this.naturalHeight) {
              $(this).addClass('landscape');
          }
          if (this.naturalWidth < this.naturalHeight) {
              $(this).addClass('portrait');
          }
      }
  })
  })


});

$(document).on('mouseover', '.demo.cursor', function(e) {
  e.preventDefault();
  e.stopPropagation();
  var container = $(e.target).closest('.slider-container');

  var wrapper = $(e.target).closest('.thumbs-wrapper');
  let transform;
  if ($('.row', container)[0].style.transform.match(/-?\d+/)) {
    transform = parseInt($('.row', container)[0].style.transform.match(/-?\d+/)[0]);
  } else {
    transform = 0
  }

  let positionRight = e.target.offsetLeft + transform + 100
  let thumbs = $('.demo.cursor', container)

  if (positionRight < 100 || (positionRight == 100 && e.target.offsetLeft > 0)) {
    $('.row', container)[0].style.transform =  'translateX('+ (transform + 100).toString() +'px)';
  }
  if (positionRight > container[0].offsetWidth || (positionRight == container[0].offsetWidth && parseInt($(e.target).attr('data-showslide')) < thumbs.length)) {
    $('.row', container)[0].style.transform =  'translateX('+ (transform - 100).toString() +'px)';
  }
})





  $(document).on('click', '.mySlides a', function (event) {
    event.preventDefault();
    event.stopPropagation();
    var options = { index: event.target, event: event }
    var links = $('.mySlides a', $(event.target).parent().parent().parent())
    blueimp.Gallery(links, options)
   });

