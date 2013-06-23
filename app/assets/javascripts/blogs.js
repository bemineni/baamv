// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.



/*
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
	 
$(document).ready(function()
{
    $('#blog_body').live('keydown',function(event){
    	if(event.which == 9)
		{
			event.preventDefault();
			$('#blog_body').insertAtCaret("\t");
		}
    });

    
});

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
*/