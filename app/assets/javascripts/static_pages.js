

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


  $('#baamvmodal').append('<div id="blind" />')
        .find('#blind')
        .css('opacity', '0')
        .fadeTo(500, 0.8)
        .click(function(e){
            closeModal();
        });
        disable_scroll();

  });
});
