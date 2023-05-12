require 'httpparty'
require 'dotenv/load'

module WompiApi
  module_function

  def get_acceptance_token
    response = HTTParty.get(
      "https://sandbox.wompi.co/v1/merchants/#{ENV["PUBLIC_TOKEN"]}"
    )
  
    response['data']['presigned_acceptance']['acceptance_token']
  end
end