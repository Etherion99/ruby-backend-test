require 'sinatra'
require 'pg'
require 'dotenv/load'
require_relative 'controllers/drivers_controller'
require_relative 'controllers/riders_controller'
require_relative 'controllers/rides_controller'

db_params = {
  host: ENV['DB_HOST'],
  port: ENV['DB_PORT'],
  dbname: ENV['DB_NAME'],
  user: ENV['DB_USER'],
  password: ENV['DB_PASSWORD']
}

db = PG::Connection.new(db_params)

# Rutas de riders
use RidersController

# Rutas de drivers
use DriversController

# Rutas de drivers
use RidesController

get '/' do
  'API'
end


