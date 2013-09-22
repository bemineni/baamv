// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.





    /************************************************************************************************
    * New UI
    *************************************************************************************************/

   $(document).ready(function(){

    //Side box high lighting
   $(".side-box > ol > li  a").hover(function(){
   
       $(this).parent().parent().addClass("highlight-active");

   },function(){

       $(this).parent().parent().removeClass("highlight-active");       
   });

   //List all popups here
   var popupmenus = $("#izmenu  ul  ul");

   //Close all menu popups
   $('html').click(function(){
        //Close all menu's
        $(popupmenus).slideUp('fast');

   });
 

   liheadingitems = $('#izmenu > ul > .menu-heading');
   $('a' , liheadingitems).click(function(event)
   {
        $(popupmenus).slideUp('fast');
        var height = $(this).parent().outerHeight() + 1;
        $("ul",$(this).parent()).css('top',  height.toString() + 'px');
        $("ul",$(this).parent()).slideDown('fast');
        event.stopPropagation();
   });
});