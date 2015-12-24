require 'rubygems'
require 'sinatra'
require './web_note_mongo'
require 'haml'
require 'uri'

MONGO_ID_REGEX = /\/\h{24}/
@@TAGS = ['title', 'text', 'tags', 'otp']

before do
  WebNoteMongo.connect()
end

get MONGO_ID_REGEX do
  @note = WebNoteMongo.find_by_id(get_id)
  if @note
    haml :show
  else
    redirect to "/"
  end
end

get '/:tag' do
  #show notes tagged with :tag
  render_note_list([ params[:tag] ])
end

get /(\/[^\/]+){2,}/ do
  path = URI.unescape(request.path_info)

  render_note_list( path.split('/').drop(1) )
end

post '/' do
  if authorized?
    params['tags'] =
      WebNoteMongo.connect.db.eval("tokenizeTags('#{params['tags']}')")

    redirect to "/#{WebNoteMongo.save(params)}"
  else
    halt 401, 'try over https'
  end
end

post '/vocab' do
end

def render_note_list(tags)
  #todo: add .ssl field to note; if true, only show note over HTTPS
  @tagged_noteset = WebNoteMongo.find_by_tag(tags)
  case @tagged_noteset.count
  when 0 then halt 404, "no notes found with tag(s):#{tags.join(',')}"
  when 1 then redirect to "/#{@tagged_noteset.first['_id']}"
  else
    haml :tag
  end
end

def get_id
  request.path_info.split('/').last
end

def authorized?
  request.env['HTTP_SSL_CLIENT_VERIFY'] == 'SUCCESS'
end

helpers do
  def note_link_text(note)
    note["title"] || note["text"][0...80]
  end

  def note_output(note)
    text = note['text']
    language = note['language']

    begin
      case language
      when nil
        text
      when 'ruby'
        eval text
      when 'javascript'
        "<script>#{text}</script>"
      else
        input = <<RUBY
#{language} <<'BASH'
#{text}
BASH
RUBY

        %x(#{input})
      end
    rescue Exception => e
      error_message = "#{e.message}\n#{e.backtrace.join("\n")}"

      STDERR.puts error_message

      "#{text}\n#{error_message}"
    end
  end
end
