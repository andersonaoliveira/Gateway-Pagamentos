class Api::V1::ChargesController < Api::V1::ApiController
  def create
    charge_params = params.permit(:id_order, :product_group_id, :order_value, :cupom_code, :credit_card_token,
                                  :client_eni, :qty_instalments)
    charge = Charge.new(charge_params)
    if charge.save
      render json: charge.as_json(except: %i[product_group_id order_value cupom_code credit_card_token
                                             qty_instalments updated_at created_at]), status: :created
    else
      render status: :unprocessable_entity, json: charge.errors.full_messages
    end
  end
end
