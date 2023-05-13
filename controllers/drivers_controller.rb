require_relative '../models/driver'
require_relative '../models/ride'
require_relative '../lib/validations'
require 'sinatra/base'

class DriversController < Sinatra::Base
  # Basic CRUD
  get '/drivers' do
    content_type :json
    drivers = Driver.all
    drivers.to_json
  end

  get '/drivers/:id' do
    content_type :json
    driver = Driver.where(driver_id: params[:id]).first

    if driver
      driver.to_json
    else
      status 404
      { error: "Driver con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  post '/drivers' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    contract = DriverContract.new.call(request_body)

    if contract.success?
      driver = Driver.new(
        name: request_body['name'],
        email: request_body['email'],
        phone: request_body['phone']
      )
  
      if driver.save
        status 201
        driver.to_json
      else
        status 400
        { error: driver.errors.full_messages }.to_json
      end
    else
      status 422
      { message: "Validation error", errors: contract.errors.to_h }.to_json
    end    
  end

  put '/drivers/:id' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    driver = Driver.where(driver_id: params[:id]).first

    if driver
      driver.name = request_body['name'] if request_body['name']
      driver.email = request_body['email'] if request_body['email']
      driver.phone = request_body['phone'] if request_body['phone']

      if driver.save
        driver.to_json
      else
        status 400
        { error: driver.errors.full_messages }.to_json
      end
    else
      status 404
      { error: "Driver con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  delete '/drivers/:id' do
    content_type :json
    driver = Driver.where(driver_id: params[:id]).first

    if driver
      id = driver.driver_id
      driver.destroy
      { deleted: id }.to_json
    else
      status 404
      { error: "Driver con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  # Custom Endpoints
end





