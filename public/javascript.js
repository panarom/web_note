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
							{'otp':$("#pin").val()},
							success_function
						);
					},
					"Cancel" : function() { $(this).dialog("close"); }
				}
			});
		}
	);
}

function success_function(data, textStatus, jqXHR) {
	console.log( data );
}