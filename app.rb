require 'sinatra'
require 'pg'
require 'dotenv/load'

db_params = {
  host: ENV['DB_HOST'],
  port: ENV['DB_PORT'],
  dbname: ENV['DB_NAME'],
  user: ENV['DB_USER'],
  password: ENV['DB_PASSWORD']
}

db = PG::Connection.new(db_params)

get '/' do
  'API'
end


