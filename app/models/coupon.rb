class Coupon < ApplicationRecord
  belongs_to :sale
  validates :code, uniqueness: true
  validates :code, presence: true
  validate :sale_status, on: :create
  enum status: { unused: 0, used: 1 }

  before_validation :generate_code

  def sale_status
    return errors.add('Não foi possível gerar o cupom') unless sale.can_generate_coupons?
  end

  private

  def generate_code
    self.code = "#{sale.name}-#{SecureRandom.alphanumeric(6)}".upcase
  end
end
