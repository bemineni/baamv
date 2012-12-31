// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function( $ ){
  
$.fn.insertAtCaret=function(myValue)
					{
  						return this.each(function(i) 
  						{
    						if (document.selection) 
    						{
      							//For browsers like Internet Explorer
      							this.focus();
      							sel = document.selection.createRange();
      							sel.text = myValue;
      							this.focus();
    						}
    						else if (this.selectionStart || this.selectionStart == '0') 
    						{
      							//For browsers like Firefox and Webkit based
      							var startPos = this.selectionStart;
      							var endPos = this.selectionEnd;
      							var scrollTop = this.scrollTop;
      							this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
      							this.focus();
      							this.selectionStart = startPos + myValue.length;
      							this.selectionEnd = startPos + myValue.length;
      							this.scrollTop = scrollTop;
    						} 
    						else 
    						{
      							this.value += myValue;
      							this.focus();
    						}
  						});
					};

})(jQuery);


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