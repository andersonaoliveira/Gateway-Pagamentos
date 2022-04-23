class Api::V1::CouponsController < Api::V1::ApiController
  def validate_coupon
    @coupon = Coupon.find_by(code: params[:code])

    return render json: '{"coupon": "inválido", "error": "Cupom não encontrado"}' if @coupon.nil?

    check_expiration
  end

  def check_expiration
    date = @coupon.sale.expiration_date

    return render json: '{"coupon": "inválido", "error": "Promoção expirada"}' if date < DateTime.now

    check_product_group
  end

  def check_product_group
    pg_in = params[:product_group]
    coupon_pg_name = ProductGroup.find(@coupon.sale.product_group_id).name
    if coupon_pg_name == pg_in
      return_discount
    else
      render json: '{"coupon": "inválido", "error": "O cupom não é válido para este grupo de produtos"}'
    end
  end

  def return_discount
    sale = Sale.find(@coupon.sale_id)
    total = params[:total].to_f
    discount = if total * (sale.discount / 100) <= sale.max_value
                 total * (sale.discount / 100)
               else
                 sale.max_value
               end
    render json: '{"coupon": "válido", "desconto": "'"#{discount}"'"}', status: :ok
  end
end
