module Utils
  module_function

  def calculate_cost(distance_km, duration_min, base)
    base + 200*duration_min + 1000*distance_km
  end

  # This is just an estimation based on Haversine's equation, for more accurate results it would be necessary to implement a maps API such as Google maps or Mapbox.
  def calculate_distance(start_lat, start_lng, end_lat, end_lng)
    radius = 6371  # Earth radius [km]
  
    delta_lat = end_lat - start_lat
    delta_lng = end_lng - start_lng
  
    a = Math.sin(delta_lat / 2) ** 2 + Math.cos(start_lat) * Math.cos(end_lat) * Math.sin(delta_lng / 2) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  
    distance = radius * c  # distance [km]
  
    return distance
  end

  # This is just an estimation provided as an example, for more accurate results it would be necessary to implement a maps API such as Google maps or Mapbox.
  def calculate_duration(distance_km)
    3*distance_km
  end
end