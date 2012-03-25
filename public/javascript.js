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
			$('#' + id_url.split('/').pop()).load(id_url + ' #note_content');
		}
	)
}

tag_accordion=function()
{
	$('#tag_accordion').accordion(
		{active: false,
		 collapsible: true,
		 change: function(event, ui) {
			 ui.newHeader.next('div').load('notes.0xf1d0.net');
		 }
		}
	)
}