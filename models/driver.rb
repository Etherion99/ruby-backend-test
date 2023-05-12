class Driver < Sequel::Model(:drivers)
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
  end

  def to_json(*args)
    {
      driver_id: driver_id,
      name: name,
      email: email,
      phone: phone,
      created_at: created_at
    }.to_json(*args)
  end
end