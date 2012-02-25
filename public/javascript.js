delete_note=function()
{

	$("#delete_link").click(
		function(event)
		{
			event.preventDefault();
			$( "#delete_dialog" ).dialog({
				modal: true,
				buttons : {
					"Confirm" : function() {
						$.post(
							event.currentTarget.href,
							{'otp':$("#pin").text()}
						);
					},
					"Cancel" : function() { $(this).dialog("close"); }
				}
			});
		}
	);
}
