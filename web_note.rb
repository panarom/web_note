require 'rubygems'
require 'sinatra'
require "sinatra/reloader"
require 'web_note_mongo'

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
  #list latest & enter new
end

get '/:tag' do
  #show notes tagged with :tag
  WebNoteMongo.find_by_tag(params[:tag]).join('<br/>')
end
