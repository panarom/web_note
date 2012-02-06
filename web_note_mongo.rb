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
      @db.collection(COLLECTION_NAME).find({"tags"=>tag}).sort(["_id",Mongo::ASCENDING])
    end

    def find_by_id(oid)
      @db.collection(COLLECTION_NAME).find_one( BSON::ObjectId.from_string(oid) )
    end

    def save(note)
      @db.collection(COLLECTION_NAME).save(note)
    end
  end
end
