require 'rubygems'
require 'sinatra'
require "sinatra/reloader"
require 'web_note_mongo'
require 'haml'

MONGO_ID_REGEX = /\/[0-9a-f]{24}/
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
  render_note_list( request.path_info[1..-1].split('/') )
end

def render_note_list(tags)
  @tagged_noteset = WebNoteMongo.find_by_tag(tags)
  case @tagged_noteset.count
  when 0 halt 404
  when 1
    redirect to "/#{@tagged_noteset.first['_id']}"
  else
    haml :tag
  end
end

def get_id
  request.path_info.split('/')[1]
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
