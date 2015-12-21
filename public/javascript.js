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

separate_tag_string=function(event)
{
  var tags = $('#tags');
  var text = tags.val();
  var separator = text.slice(-1);
  tags.val(text.slice(0,-1)
           .replace(new RegExp(separator,'g'),
                    '\u001f'));
};
