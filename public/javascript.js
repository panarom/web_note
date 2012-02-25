delete_note=function()
{

	$("#delete_link").click({href: $(this).attr('href')},
		function(event)
		{
			event.preventDefault();
			$( "#delete_dialog" ).dialog({
				autoOpen: false,
				modal: true,
				buttons : {
					"Confirm" : function() {
						$.post(
							eventData['href'],
							{'otp':$("#pin").text()}
						);
					},
					"Cancel" : function() { $(this).dialog("close"); }
				}
			});
		}
	);
}
