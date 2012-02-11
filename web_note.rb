require 'rubygems'
require 'sinatra'
require "sinatra/reloader"
require 'web_note_mongo'
require 'haml'

MONGO_ID_REGEX = /\/[0-9a-f]{24}/

before do
  WebNoteMongo.connect()
end

get '/' do
  haml :edit
end

post '/' do
  save_note()
end

get MONGO_ID_REGEX do
  @note = WebNoteMongo.find_by_id(request.path_info[1..-1])
  haml :show
end

post MONGO_ID_REGEX do
  save_note()
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
  params['tags'] = params['tags'].split(',').collect{ |t| t.strip }
  redirect to("/#{WebNoteMongo.save(params).to_s}")
end

helpers do
  def note_link_text(note)
    note["title"] || note["text"][0...80]
  end
end
