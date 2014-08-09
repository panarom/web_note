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
