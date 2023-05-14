class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :offer

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled, guard: :coins_enough?, success: [:cancel_coins, :decrease_deposit]
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: :pay_coins
    end
  end

  def pay_coins
    if genre != 'deduct'
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def cancel_coins
    if genre == 'deduct'
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def coins_enough?
    user.coins >= coin
  end

  def decrease_deposit
    user.update(total_deposit: user.total_deposit - amount) if genre == 'deposit'
  end

  def generate_serial_number
    number_count = Order.where(user_id: user_id).count.to_s.rjust(4, '0')
    serial_number = "#{Time.current.strftime("%y%m%d")}-#{order.id}-#{user_id}-#{number_count}"
    self.update(serial_number: serial_number)
  end
end
