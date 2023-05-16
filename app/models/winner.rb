class Winner < ApplicationRecord
  include AASM

  scope :filter_by_serial_number, -> (serial_number) { where(bets: {serial_number: serial_number}) }
  scope :filter_by_item_name, -> (item_name) { where(items: {name: item_name}) }
  scope :filter_by_email, -> (email) { joins(:user).where(users: { email: email }) }
  scope :filter_by_state, -> (state) { where(state: state) }
  scope :filter_by_date_range, -> (date_range) { where({created_at: date_range}) }

  belongs_to :user
  belongs_to :bet
  belongs_to :item
  belongs_to :admin, class_name: 'User', optional: true
  belongs_to :user_address, optional: true

  aasm column: :state do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped,
          :delivered, :shared,
          :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :removed_published
    end
  end
end
