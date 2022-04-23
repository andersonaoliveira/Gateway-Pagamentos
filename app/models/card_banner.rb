class CardBanner < ApplicationRecord
  has_one_attached :icon
  validates :name, :max_instalments, :discount, :percentual_tax, :max_tax,
            presence: true
  enum status: { active: 1, inactive: 0 }
  validates :name,
            uniqueness: true
end
