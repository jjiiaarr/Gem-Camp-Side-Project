class Bet < ApplicationRecord
  include AASM


  scope :filter_by_serial_number, -> (serial_number) { where(bets: {serial_number: serial_number}) }
  scope :filter_by_item_name, -> (item_name) { join(:item).where(items: {name: item_name}) }
  scope :filter_by_email, -> (email) { join(:user).where(users: {name: email}) }
  scope :filter_by_state, -> (state) { where(bets: {name: state}) }
  scope :filter_by_date_range, -> (date_range) { where(items: {created_at: date_range}) }

  validates :coins, numericality: { greater_than: 0 }
  belongs_to :user
  belongs_to :item
  after_create :deduct_coins, :generate_serial_number
  after_validation :coins_available?

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :return_coins
    end
  end

  def return_coins
    self.user.update(coins: self.user.coins + 1)
  end

  def deduct_coins
    self.user.update(coins: self.user.coins - 1)
  end

  def generate_serial_number
    number_count = Bet.where(batch_count: batch_count, item: item_id).count.to_s.rjust(4, '0')
    serial_number = "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}"
    self.update(serial_number: serial_number)
  end

  def coins_available?
    errors.add(:base, "You don't have enough coins") if self.user.coins < 1
  end
end
