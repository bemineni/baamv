// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) 
{
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().prepend(content.replace(regexp, new_id));
}

function change_display(image)
{
    alert(image);
    $('#image-id').attr("src",image);
}

function insertString(val)
{
	switch(val)
	{
		case 0:
				$('#blog_body').insertAtCaret("<b></b>");
				break;
		case 1:
				$('#blog_body').insertAtCaret("<code lang=\"c++\"></code>");
				break;
	}
}

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

function wheel(e) 
{
  preventDefault(e);
}

function disable_scroll() 
{
  if (window.addEventListener) {
      window.addEventListener('DOMMouseScroll', wheel, false);
  }
  window.onmousewheel = document.onmousewheel = wheel;
  document.onkeydown = keydown;
}

function enable_scroll() 
{
    if (window.removeEventListener) {
        window.removeEventListener('DOMMouseScroll', wheel, false);
    }
    window.onmousewheel = document.onmousewheel = document.onkeydown = null;  
}


function closeModal()
{
    // fade out window and then move back to off screen when fade completes
    activeWindow.fadeOut(250, function(){ $(this).css('top', '-1000px').css('left', '-1000px'); });


    // fade out blind and then remove it
    $('#blind').fadeOut(250,function(){	
    	  $(this).remove(); 
      });

    enable_scroll();

}

$(document).ready(function(){

	$('a.close').click(function(e){
            // cancel default behaviour
            e.preventDefault();


            // call the closeModal function passing this close button's window
            closeModal();
    });

	$('#blog_body').on('keydown',function(event){
    	if(event.which == 9)
		{
			event.preventDefault();
			$('#blog_body').insertAtCaret("\t");
		}
    });

});


	 



