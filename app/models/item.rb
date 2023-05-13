class Item < ApplicationRecord

  scope :filter_by_category, -> (category_name) { includes(:categories).where(categories: { name: category_name }) }

  validates :category_ids, presence: true
  validates :image, presence: true
  validates :name, presence: true, uniqueness: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :minimum_bets, presence: true, numericality: { greater_than: 0 }
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
  has_many :bets
  has_many :winners

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
      transitions from: :starting, to: :ended, guard: :bets_limit?, success: :pick_winner
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, success: :cancel_bets
    end
  end

  private

  def can_start?
    quantity > 0 && Time.current < offline_at && status == 'active'
  end

  def cancel_bets
    bets.where(batch_count: batch_count).each do |bet|
      bet.cancel! if bet.may_cancel?
    end
  end

  def bets_limit?
    bets.betting.where( batch_count: batch_count).count >= minimum_bets
  end

  def pick_winner
    betting_list = bets.where(batch_count: batch_count, state: :betting)
    winner_bet = betting_list.sample
    winner_bet.win!
    betting_list.where.not(id: winner_bet.id).update_all(state: :lost)
    winners.create!(
      user: winner_bet.user,
      item_batch_count: batch_count,
      user_address: winner_bet.user.user_addresses.find_by(is_default: true),
      bet: winner_bet,
      admin: User.find_by(genre: 1)
    )
  end
end

