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
							delete_note_success_function
						);
					},
					"Cancel" : function() { $(this).dialog("close"); }
				}
			});
		}
	);
}

function delete_note_success_function(data, textStatus, jqXHR) {
	console.log( data );
}

get_note_text=function()
{
	$("a.link_to_note").click(
		function(event)
		{
			var id_url = event.currentTarget.href;
			event.preventDefault();
			var note_content_div_selector = $( '#' + id_url.split('/').pop() )
			if ( note_content_div_selector.is(':empty') ) {
					note_content_div_selector.load(id_url + ' #note_content');
			} else {
				note_content_div_selector.empty()
			}
		}
	)
}
