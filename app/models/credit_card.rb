require 'date'

class CreditCard < ApplicationRecord
  belongs_to :card_banner

  validates :holder_name, :cpf, :number, :valid_date, :security_code, :token,
            presence: true
  validates :token, format: { with: /\A[A-Z0-9]{20}\z/ }
  validates :token, uniqueness: true, on: :create
  validates :number, uniqueness: true
  validate :validate_valid_date, on: :create

  before_validation :generate_token

  private

  def validate_valid_date
    return false if valid_date == ''

    arr = valid_date.split('-')
    date_validate = DateTime.new(arr[0].to_i, arr[1].to_i, -1)
    errors.add(:valid_date, 'Data de validade inválida') if date_validate < DateTime.now
  end

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end
end
