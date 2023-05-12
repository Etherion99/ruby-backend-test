require_relative '../models/rider'
require_relative '../models/ride'
require_relative '../shared/wompi_api'
require_relative '../shared/utils'
require 'sinatra/base'
require 'httpparty'
require 'dotenv/load'

class RidersController < Sinatra::Base
  # Basic CRUD
  get '/riders' do
    content_type :json
    riders = Rider.all
    riders.to_json
  end

  get '/riders/:id' do
    content_type :json
    rider = Rider.where(rider_id: params[:id]).first

    if rider
      rider.to_json
    else
      status 404
      { error: "Rider con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  post '/riders' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    rider = Rider.new(
      name: request_body['name'],
      email: request_body['email'],
      phone: request_body['phone'],
      tokenized_card_id: request_body['tokenized_card_id']
    )

    if rider.save
      status 201
      rider.to_json
    else
      status 400
      { error: rider.errors.full_messages }.to_json
    end
  end

  put '/riders/:id' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    rider = Rider.where(rider_id: params[:id]).first

    if rider
      rider.name = request_body['name'] if request_body['name']
      rider.email = request_body['email'] if request_body['email']
      rider.phone = request_body['phone'] if request_body['phone']
      rider.tokenized_card_id = request_body['tokenized_card_id'] if request_body['tokenized_card_id']

      puts rider.to_json

      if rider.save
        rider.to_json
      else
        status 400
        { error: rider.errors.full_messages }.to_json
      end
    else
      status 404
      { error: "Rider con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  delete '/riders/:id' do
    content_type :json
    rider = Rider.where(rider_id: params[:id]).first

    if rider
      id = rider.rider_id
      rider.destroy
      { deleted: id }.to_json
    else
      status 404
      { error: "Rider con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  # custom endpoints
  post '/riders/create_payment_method' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    rider = Rider.where(rider_id: request_body['id']).first

    create_payment_response = HTTParty.post(
      'https://sandbox.wompi.co/v1/payment_sources',
      body: {
        type: request_body['type'],
        token: rider.tokenized_card_id,
        customer_email: request_body['customer_email'],
        acceptance_token: WompiApi.get_acceptance_token()
      }.to_json,
      headers: {
        'Authorization' => "Bearer #{ENV["PRIVATE_TOKEN"]}"
      }
    )

    if rider
      create_payment_response
    else
      status 404
      { error: "Rider con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  post '/riders/request_ride' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    distance_km = Utils.calculate_distance(request_body['start_lat'], request_body['start_lng'], request_body['end_lat'], request_body['end_lng'])
    duration_min = Utils.calculate_duration(distance_km)

    ride = Ride.new(
      rider_id: request_body['rider_id'],
      driver_id: request_body['driver_id'],
      start_lat: request_body['start_lat'],
      start_lng: request_body['start_lng'],
      end_lat: request_body['end_lat'],
      end_lng: request_body['end_lng'],
      distance_km: distance_km,
      duration_minutes: duration_min,
      cost: Utils.calculate_cost(distance_km, duration_min, 3500),
      status: 'started'     
    )

    if ride.save
      status 201
      ride.to_json
    else
      status 400
      { error: "Ha ocurrido un error al crear el viaje: #{ride.errors.full_messages}" }.to_json
    end
  end
end


