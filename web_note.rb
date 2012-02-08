require 'rubygems'
require 'sinatra'
require "sinatra/reloader"
require 'web_note_mongo'
require 'haml'

before do
  WebNoteMongo.connect()
end

post '/', :host_name => /edit/ do
  #edit tag with this
end

get '/', :host_name => /latest/ do
  #show latest
end

get '/', :host_name => /search/ do
  #get search page
end
post '/', :host_name => /search/ do
  #post search
end

post '/', :host_name => /edit/ do
  #edit tag with this
end

get '/' do
  haml :edit
end

post '/' do
  params['tags'] = params['tags'].split(',').collect{ |t| t.strip }
  redirect to("/#{WebNoteMongo.save(params).to_s}")
end

get /\/[0-9a-f]{24}/ do
  @note = WebNoteMongo.find_by_id(request.path_info[1..-1])
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

helpers do
  def note_link_text(note)
    note["title"] || note["text"][0...80]
  end
end
