$(document).ready(function(){
$('#user_country_id').change(function(){
	$.get("/common/getStates?country="+this.value,null,null,"script");
})
	
})
