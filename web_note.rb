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

def render_note_list(tags)
  @tagged_noteset = WebNoteMongo.find_by_tag(tags)
  case @tagged_noteset.count
  when 0 then halt 404, "no notes found with tag(s):#{tags.join(',')}"
  when 1 then redirect to "/#{@tagged_noteset.first['_id']}"
  else
    haml :tag
  end
end

def save_note()
  if WebNoteMongo.check_pin(params['otp'])
    params.delete('otp')
    #split tags on commas; then split any tags with spaces and add individual words as tags as well; remove duplicates
    params['tags'] = params['tags'].split(',').collect{|t| t.strip}.collect{|t| t=~/\s/ ? [t,t.split(/\s/)].flatten : t}.flatten.uniq
    redirect to("/#{WebNoteMongo.save(params).to_s}")#this may be too clever: calling 'save' from inside a string interpolation (programming-by-side-effect FTL)
  else
    params['otp'] = "INVALID PIN: #{params['otp']}"
    @note = params
    haml :edit
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
