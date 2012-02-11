require 'rubygems'
require 'mongo'

module WebNoteMongo
  DB_NAME			= 'notes'
  COLLECTION_NAME	= 'note'

  class << self
    def connect()
      @db = Mongo::Connection.new('localhost',27017).db(DB_NAME)
      @collection = @db.collection(COLLECTION_NAME)
    end

    def find_by_tag(tags)
      if tags.size == 1
        tag_hash = {'tags'=>tags[0]}
      else
        tag_hash = {
          '$and'=> tags.collect{ |t| {'tags'=>t} }
        }
      end
      @collection.find(tag_hash).sort(["_id",Mongo::DESCENDING])
    end

    def find_by_id(oid)
      @collection.find_one( BSON::ObjectId.from_string(oid) )
    end

    def save(note)
      @collection.save(note)
    end

    def delete(note)
      @collection.remove(note)
    end
  end
end
