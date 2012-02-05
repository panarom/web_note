require 'rubygems'
require 'sinatra'
require "sinatra/reloader"

get '/', :host_name => /matt-panaro/ do
  'Hello matt'
end

get '/' do
  'Hello World'
end

get '/updated' do
  'hot'
end

get '/tag/:tag' do
  'you\'re looking for entries tagged: `' + params[:tag] + '\''
end

get '/params/?' do
  #{|key,value| "#{key} => #{value}"}
  "params\n #{params.keys.size.to_s} \n&lt;EOL&gt;"
end

get '/hostname/?' do
  request.host
end
