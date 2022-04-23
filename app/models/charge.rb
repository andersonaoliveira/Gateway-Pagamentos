class Charge < ApplicationRecord
  enum status: { pending: 0, approved: 1, reproved: 2 }
  validates :credit_card_token, :id_order, :qty_instalments, :client_eni,
            :product_group_id, :order_value,
            presence: true
  validates :id_order, :client_eni, :qty_instalments,
            numericality: { only_integer: true }
  validates :credit_card_token, format: { with: /\A[A-Z0-9]{20}\z/ }
  validate :validate_id_order, on: :create
  validate :validate_credit_card_token, on: :create
  validate :validate_coupon, on: :create

  before_create :calc_total_charge

  private

  def validate_id_order
    charge = Charge.find_by(id_order: id_order)

    return true if charge.nil?

    return true if charge.reproved?

    return errors.add(:id_order, 'já existe cobrança pendente') if charge.pending?

    return errors.add(:id_order, 'já existe cobrança aprovada') if charge.approved?
  end

  def validate_credit_card_token
    credit_card = CreditCard.find_by(token: credit_card_token)

    return errors.add(:credit_card_token, 'não encontrado') if credit_card.nil?

    return errors.add(:credit_card_token, 'não associado a esse cliente') if credit_card.cpf != client_eni

    validate_instalments(credit_card.card_banner)
  end

  def validate_instalments(card_banner)
    return unless card_banner.max_instalments < qty_instalments

    errors.add(:qty_instalments, "inválida, máximo de #{card_banner.max_instalments} para essa bandeira")
  end

  def validate_coupon
    return true if cupom_code == ''

    @coupon = Coupon.find_by(code: cupom_code)

    return errors.add(:cupom_code, 'não encontrado') if @coupon.nil?

    check_expiration_sale
  end

  def check_expiration_sale
    return errors.add(:cupom_code, 'com promoção expirada') if @coupon.sale.expiration_date < DateTime.now

    check_sale_product_group
  end

  def check_sale_product_group
    coupon_product_group = ProductGroup.find(@coupon.sale.product_group_id).key
    check = coupon_product_group != product_group_id

    return errors.add(:cupom_code, 'não é válido para este grupo de produtos') if check

    check_cupom_used?
  end

  def check_cupom_used?
    return errors.add(:cupom_code, 'já utilizado') if @coupon.used?
  end

  def calc_total_charge
    coupon = Coupon.find_by(code: cupom_code)

    return self.total_charge = order_value if coupon.nil?

    return_discount(coupon)
  end

  def return_discount(coupon)
    sale = Sale.find(coupon.sale_id)
    check = order_value * (sale.discount / 100) > sale.max_value
    self.total_charge = if check
                          order_value - sale.max_value
                        else
                          order_value * (1 - (sale.discount / 100))
                        end
  end
end
