require_relative '../models/rider'
require 'sinatra/base'

class RidersController < Sinatra::Base
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
end


