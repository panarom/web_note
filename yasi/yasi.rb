require 'rubygems'
require 'sinatra'
require 'lib/yasi'

before do
	config = {:server => "localhost",
								:db => "yasi"}
	Yasi.connect config
end

get "/" do
	@yasis = Yasi.find :all
	erb :index
end

get "/new" do
	erb :new
end

get "/delete/:id" do
	Yasi.delete(params[:id])
	redirect "/"
end

post "/" do
	params.reject! {|k,v| k == "submit"}
	Yasi.save(params)
	redirect "/"
end
