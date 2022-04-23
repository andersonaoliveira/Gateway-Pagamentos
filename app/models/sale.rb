class Sale < ApplicationRecord
  validates :name, :expiration_date, :discount, :quantity, :product_group_id, :max_value, presence: true
  validates :name, uniqueness: true, on: :create

  belongs_to :admin
  belongs_to :approver, class_name: 'Admin', optional: true

  has_many :coupons, dependent: :destroy
  enum status: { pending: 0, approved: 1, disapproved: 2 }

  def can_generate_coupons?
    approved? && check_quantity
  end

  def generate_coupons
    quantity = self.quantity.to_i

    quantity.times do
      break unless can_generate_coupons?

      Coupon.create(sale_id: id)
    end
  end

  private

  def check_quantity
    coupons.count < quantity
  end
end
