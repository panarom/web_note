require 'rubygems'
require 'mongo'

module WebNoteMongo
  DB_NAME			= 'notes'
  COLLECTION_NAME	= 'note'

  class << self
    def connect()
      @db = Mongo::Connection.new('localhost',27017).db(DB_NAME)
    end

    def find_by_tag(tag)
      @db.collection(COLLECTION_NAME).find({"tags"=>tag}).to_a.sort_by {
        |bson_ordered_hash| bson_ordered_hash["_id"].generation_time }.reverse
    end

    def find_by_id(ojbect_id)
      @db.collection(COLLECTION_NAME).find_one( Mongo::ObjectID.from_string(object_id) )
    end

    def save(note)
      @db.collection(COLLECTION_NAME).save(note)
    end
  end
end
