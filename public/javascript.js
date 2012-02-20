//function
//to generate function that takes event as argument and returns data
//that takes an oid; to provide note text for expansion
function get_note_text_getter_function(oid, placeholder)
{
	return function(event) 
{
	event.preventDefault();
	$.get
	(
		"/" + oid,
		function(data)
		{
			$(placeholder).html(data);
		}
	)
}

function delete_note()
{
	$("a").click(
		var targetURL = $(this).attr("href");
		function(event)
		{
			e.preventDefault();
			$.dialog({
				buttons : {
					"Confirm" : function() { $.get(targetURL); }
					"Cancel" : function() { $(this).dialog("close"); }
				}
			})
		}
	)
}
