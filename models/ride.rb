require 'sequel'
require_relative '../config/db'

class Ride < Sequel::Model(:rides)
  many_to_one :rider
  many_to_one :driver

  def before_create
    self.created_at = Time.now
    super
  end

  def before_save
    self.updated_at = Time.now
    super
  end

  def validate
    super
    errors.add(:start_lat, 'no puede estar vacio') if !start_lat || start_lat == 0
    errors.add(:start_lng, 'no puede estar vacio') if !start_lng || start_lng == 0
    errors.add(:end_lat, 'no puede estar vacio') if !end_lat || end_lat == 0
    errors.add(:end_lng, 'no puede estar vacio') if !end_lng || end_lng == 0
    errors.add(:distance_km, 'no puede estar vacio') if !distance_km || distance_km == 0
    errors.add(:duration_minutes, 'no puede estar vacio') if !duration_minutes || duration_minutes == 0
    errors.add(:status, 'no puede estar vacio') if !status || status.empty?
    errors.add(:cost, 'no puede estar vacio') if !cost || cost == 0
  end
  
  def to_json(*args)
    {
      ride_id: ride_id,
      rider: rider.to_json,
      driver: driver.to_json,
      start_lat: start_lat,
      start_lng: start_lng,
      end_lat: end_lat,
      end_lng: end_lng,
      distance_km: distance_km,
      duration_minutes: duration_minutes,
      status: status,
      cost: cost,
      created_at: created_at
    }.to_json(*args)
  end
end