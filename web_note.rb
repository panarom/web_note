require 'rubygems'
require 'sinatra'
require 'web_note_mongo'
require 'haml'

MONGO_ID_REGEX = /\/[0-9a-f]{24}/
@@TAGS = ['title', 'text', 'tags', 'otp']

before do
  WebNoteMongo.connect()
end

get '/' do
  haml :edit
end

post '/' do
  save_note
end

get Regexp.new(MONGO_ID_REGEX.to_s + /\/edit/.to_s) do
  @note = WebNoteMongo.find_by_id(get_id)
  @note['tags'] = @note['tags'].join(',')
  haml :edit
end
post Regexp.new(MONGO_ID_REGEX.to_s + /\/edit/.to_s) do
  params['_id'] = get_id
  save_note
end

get Regexp.new(MONGO_ID_REGEX.to_s + /\/delete/.to_s) do
  haml :delete
end
post Regexp.new(MONGO_ID_REGEX.to_s + /\/delete/.to_s) do
  if WebNoteMongo.check_pin(params['otp'])
     WebNoteMongo.delete(get_id)
     redirect to '/'
   else
     redirect to "#{get_id}/delete"
   end
end

get Regexp.new(MONGO_ID_REGEX.to_s + /\/text/.to_s) do
  WebNoteMongo.find_by_id(get_id)['text']
end

get MONGO_ID_REGEX do
  @note = WebNoteMongo.find_by_id(get_id)
  haml :show
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
  if @tagged_noteset.count > 0
    haml :tag
  else
    "no notes found with tag(s):#{tags}"
  end
end

def save_note()
  if WebNoteMongo.check_pin(params['otp'])
    params.delete('otp')
    params['tags'] = params['tags'].split(',').collect{ |t| t.strip }
    redirect to("/#{WebNoteMongo.save(params).to_s}")
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
end
