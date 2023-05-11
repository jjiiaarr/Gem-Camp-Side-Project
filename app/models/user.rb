class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum genre: { client: 0, admin: 1 }

  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  mount_uploader :image, ImageUploader

  belongs_to :parent, class_name: 'User', counter_cache: :children_members, optional: true
  has_many :children, class_name: 'User', foreign_key: :parent_id

  has_many :user_address
  has_many :bets
end