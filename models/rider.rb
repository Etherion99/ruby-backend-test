require 'sequel'
require_relative '../config/db'

class Rider < Sequel::Model(:riders)
  plugin :validation_helpers
  plugin :timestamps, update_on_create: true
  one_to_many :rides

  def before_create
    self.created_at ||= Time.now
    super
  end

  def validate
    super
    errors.add(:name, 'no puede estar vacio') if !name || name.empty?
    errors.add(:email, 'no puede estar vacio') if !email || email.empty?
    errors.add(:phone, 'no puede estar vacio') if !phone || phone.empty?
    errors.add(:tokenized_card_id, 'no puede estar vacio') if !tokenized_card_id || tokenized_card_id.empty?
  end

  def to_json(*args)
    {
      rider_id: rider_id,
      name: name,
      email: email,
      phone: phone,
      tokenized_card_id: tokenized_card_id,
      created_at: created_at
    }.to_json(*args)
  end
end