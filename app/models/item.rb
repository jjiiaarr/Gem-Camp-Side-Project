class Item < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
end
