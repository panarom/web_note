require 'rubygems'
require 'mongo'

module WebNoteMongo
  DB_NAME			= 'notes'
  #COLLECTION_NAME	= 'note'

  class << self
    def connect()
      unless @db.respond_to?(:active?) && @db.active?
        @db = Mongo::Connection.new('localhost',27017).db(DB_NAME)
        @collection = @db.collection(DB_NAME)#COLLECTION_NAME)
      end

      return @collection
    end

    def find_by_tag(tags, is_authorized)
      tag_hash =
        if tags.size == 1
          {'tags'=>tags.first}
        else
          { '$and'=> tags.collect{ |t| {'tags'=>t} } }
        end

      @collection.find(unauthorized_search(tag_hash, is_authorized))
        .sort(["_id",Mongo::DESCENDING])
    end

    def find_by_id(oid, is_authorized)
      id = {'_id' => str_to_obj_id(oid)}

      @collection.find_one(unauthorized_search(id, is_authorized))
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

    def unauthorized_search(tag_hash, is_authorized)
      if is_authorized
        tag_hash
      else
        auth  = Proc.new{|h| h << {authorized_only: {'$exists' => false}}}

        if tag_hash.keys.include?('$and')
          tag_hash.tap{|h| auth.call(h['$and'])}
        else
          {'$and' => auth.call(Array[tag_hash])}
        end
      end
    end
  end
end
