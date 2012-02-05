require 'rubygems'
require 'sinatra'
require 'lib/note'

before do
  Note.connect(
               {:server => 'localhost'
                 :db => "notes"})
end

get "/" do
  @notes = Note.find :all
  erb :index
end

