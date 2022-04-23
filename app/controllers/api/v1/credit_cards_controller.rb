class Api::V1::CreditCardsController < Api::V1::ApiController
  def create
    credit_cards_params = params.permit(:holder_name, :cpf, :card_banner_id,
                                        :number, :valid_date, :security_code)
    cc = CreditCard.new(credit_cards_params)
    if cc.save
      render json: cc, status: :created
    else
      render status: :unprocessable_entity, json: cc.errors.full_messages
    end
  end
end
