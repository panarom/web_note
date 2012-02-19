//function
//to generate function that takes event as argument and returns data
//that takes an oid; to provide note text for expansion
function(event) 
{
	event.preventDefault();
	$.get
	(
		"http://localhost:4567/secret",
		function(data)
		{
			$(placeholder).html(data);
		}
	)
}

function()
{
	$("delete").click(
		function(event)
		{
			alert()//are you sure?
			//ajax call delete
		}
	)
}

