require 'mongo'

class Db
  Mongo::Logger.logger.level = ::Logger::FATAL

  def Db.stock(cigarette)
    begin
      client = Mongo::Client.new(['127.0.0.1:27017'], database: 'tabacchi')
      client[:cigarettes].update_one({cigarette_id: cigarette[:cigarette_id]}, {'$set' => {cigarette_attributes: cigarette[:cigarette_attributes]}}, upsert: true )
    rescue => error
      puts error.message
    ensure
      client.close
    end
  end

  def Db.update(cigarette)
    begin
      client = Mongo::Client.new(['127.0.0.1:27017'], database: 'tabacchi')
      client[:cigarettes].replace_one({cigarette_id: cigarette[:cigarette_id]}, cigarette)
    rescue error
      puts error.message
    ensure
      client.close
    end
  end
end






