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
  if not (params['text'].empty? and params['title'].empty?)
    save_note
  else
    redirect to "#{params['tags'].delete(' ','').tr(',','/')}"
  end
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
  when 0 then "no notes found with tag(s):#{tags.join(',')}"
  when 1
    redirect to "/#{@tagged_noteset.first['_id']}"
  else
    haml :tag
  end
end

def save_note()
  if WebNoteMongo.check_pin(params['otp'])
    params.delete('otp')
    #split tags on commas; then split any tags with spaces and add individual words as tags as well
    params['tags'] = params['tags'].split(',').collect{|t| t.strip}.collect{|t| t=~/\s/ ? [t,t.split(/\s/)].flatten : t}.flatten
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
