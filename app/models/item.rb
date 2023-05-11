class Item < ApplicationRecord

  validates :category_ids, presence: true
  validates :image, presence: true
  validates :name, presence: true, uniqueness: true
  validates :quantity, presence: true, numericality: {greater_than: 0}
  validates :minimum_bets, presence: true, numericality: {greater_than: 0}
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :start_at, presence: true
  validates :status, presence: true

  mount_uploader :image, ImageUploader

  enum status: { active: 0, inactive: 1 }

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting, if: :can_start?
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  private

  def can_start?
    quantity > 0 && Time.current < offline_at && status == 'active'
  end
end
