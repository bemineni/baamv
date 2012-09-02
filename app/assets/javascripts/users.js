$(document).ready(function(){
$('#user_country').change(function(){
	$.get("/common/getStates?country="+this.value,null,null,"script");
})
	
})
