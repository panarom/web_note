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
  #list latest & enter new
end

=begin
get /regex-for-obj-id/ do #or %r{regex-for-obj-id}
=end

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
