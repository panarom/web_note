require 'json'
require 'cgi'
require 'mongo'

#json_objects = ARGV.collect{ |f| File.open(f,'r') }.collect{ |f| JSON.parse(f.read) }; nil
json_objects = [JSON.parse(File.open('/home/foo/Documents/starred-items.json','r').read)]

DB_NAME	= 'notes'
db = Mongo::Connection.new('localhost',27017).db(DB_NAME)
collection = db.collection(DB_NAME)

def get_labels(i)
  i['categories'].select{ |j| j=~/user\/12022370590571532258\/label\//}
end

def parse_labels(labels)
  labels.collect{ |e| e.split('/').last } #.select{ |e| not e=~/reference/ }
end

def make_note(e)
  note = {}
  note['title'] = e[:text][0..150]
  note['text'] = e[:text]
  note['tags'] = e[:tags]
  note
end

json_objects.each do |o|
  o['items'].select{ |i| not get_labels(i).empty? }.collect {
    |e| {:tags=>parse_labels(get_labels(e)), :title=>e['title'], :text=>(e['summary'] ? e['summary'] : (e['content'] ? e['content'] : e['annotations'][0]))['content']}
  }.each do |e|
    collection.save( make_note(e) )
  end
end
