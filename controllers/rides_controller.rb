require_relative '../models/ride'
require 'sinatra/base'

class RidesController < Sinatra::Base
  # Basic endpoints
  get '/rides' do
    content_type :json
    rides = Ride.all
    rides.to_json
  end

  get '/rides/:id' do
    content_type :json
    ride = Ride.where(ride_id: params[:id]).first

    if ride
      ride.to_json
    else
      status 404
      { error: "Ride con ID: #{params[:id]} no encontrado" }.to_json
    end
  end

  # Custom Endpoints
  post '/rides/request_ride' do
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

  post '/rides/finish_ride' do
    content_type :json
    request_body = JSON.parse(request.body.read)

    ride = Ride.where(ride_id: request_body['ride_id']).first

    if ride
      distance_km = Utils.calculate_distance(ride.start_lat, ride.start_lng, ride.end_lat, ride.end_lng)
      duration_min = Utils.calculate_duration(distance_km)
      cost = Utils.calculate_cost(distance_km, duration_min, 3500)

      ride.end_lat = request_body['end_lat'] if request_body['end_lat']
      ride.end_lng = request_body['end_lng'] if request_body['end_lng']
      ride.distance_km = distance_km if distance_km
      ride.duration_minutes = duration_min if duration_min
      ride.cost = cost if cost
      ride.status = 'completed' if distance_km && duration_min && cost

      if ride.save
        ride.to_json
      else
        status 400
        { error: driver.errors.full_messages }.to_json
      end
    else
      status 404
      { error: "Ride con ID: #{params[:id]} no encontrado" }.to_json
    end
  end
end





