class UserAddress < ApplicationRecord

  MAX_ADDRESS = 5

  enum genre: { home: 0, office: 1 }

  validates :phone, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  validate :number_of_addresses, on: :create

  private

  def number_of_addresses

    if user.user_address.count >= MAX_ADDRESS
      errors.add(:base,"You have reached the maximum number of addresses.")
    end
  end
end
