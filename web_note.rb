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
  params['tags'] = params['tags'].split(',')
  redirect to("/#{WebNoteMongo.save(params).to_s}")
end

get /\/[0-9a-f]{24}/ do
  @note = WebNoteMongo.find_by_id(request.path_info[1..-1])
  haml :show
end


get '/:tag' do
  #show notes tagged with :tag
  @tagged_noteset = WebNoteMongo.find_by_tag(params[:tag])
  haml :tag
end

helpers do
  def note_link_text(note)
    note["title"] || note["text"][0...80]
  end
end
