require 'rubygems'
require 'mongo'

module WebNoteMongo
  DB_NAME = :notes

  class << self
    def connect()
      @collection ||= Mongo::Client.new("mongodb://#{ENV['MONGO_DB']}/#{DB_NAME.to_s}")[DB_NAME]
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
      @collection.find( str_to_obj_id(oid) ).first
    end

    def save(note)
      note['_id'] = str_to_obj_id(note['_id']) if note['_id']
      @collection.save(note)
    end

    def delete(oid)
      @collection.remove({'_id'=>str_to_obj_id(oid)})
    end

    def check_pin(pin)
      @db.collection('PIN').remove({'pin'=>pin.strip}, {:safe=>true})["n"] > 0
    end

    def str_to_obj_id(oid)
      BSON::ObjectId.from_string(oid)
    end
  end
end
