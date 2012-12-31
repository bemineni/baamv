// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// left: 37, up: 38, right: 39, down: 40,
// spacebar: 32, pageup: 33, pagedown: 34, end: 35, home: 36
var keys = [37, 38, 39, 40];

function preventDefault(e) {
  e = e || window.event;
  if (e.preventDefault)
      e.preventDefault();
  e.returnValue = false;  
}

function keydown(e) {
    for (var i = keys.length; i--;) {
        if (e.keyCode === keys[i]) {
            preventDefault(e);
            return;
        }
    }
}

function wheel(e) {
  preventDefault(e);
}

function disable_scroll() {
  if (window.addEventListener) {
      window.addEventListener('DOMMouseScroll', wheel, false);
  }
  window.onmousewheel = document.onmousewheel = wheel;
  document.onkeydown = keydown;
}

function enable_scroll() {
    if (window.removeEventListener) {
        window.removeEventListener('DOMMouseScroll', wheel, false);
    }
    window.onmousewheel = document.onmousewheel = document.onkeydown = null;  
}

$(document).ready( function()
{
	// create variable to hold the current modal window
    var activeWindow;


	$('a.dialogopener').click(function(e){
		e.preventDefault();
		var id = $(this).attr("href");


		activeWindow = $('.bwindow#' + id)
        .css('opacity', '0')
        .css('top', $(window).scrollTop())
        .css('left', '50%')
        .fadeTo(500, 1);


        $(activeWindow).find("#image-id").attr("src" , $(this).attr("data-src") );


    $('#baamvmodal')
        .append('<div id="blind" />')
        .find('#blind')
        .css('opacity', '0')
        .fadeTo(500, 0.8)
        .click(function(e){
            closeModal();
        });

        disable_scroll();

	});

	$('a.close').click(function(e){
            // cancel default behaviour
            e.preventDefault();


            // call the closeModal function passing this close button's window
            closeModal();
    });		


    function closeModal()
    {


        // fade out window and then move back to off screen when fade completes
        activeWindow.fadeOut(250, function(){ $(this).css('top', '-1000px').css('left', '-1000px'); });


        // fade out blind and then remove it
        $('#blind').fadeOut(250,	function(){	$(this).remove(); });

        enable_scroll();


    }
});