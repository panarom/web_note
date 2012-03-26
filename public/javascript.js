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
						var delete_url = event.currentTarget.href;
						$.post(
							delete_url,
							{'otp':$("#pin").val()}
						);
						var id_url = delete_url.split('/');
						id_url.pop();
						//redirect to note's url: if note was successfully deleted,
						//that will redirect to homepage; otherwise, back at note
						window.location = id_url.join('/');
					},
					"Cancel" : function() { $(this).dialog("close"); }
				}
			});
		}
	);
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
