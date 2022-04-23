class ChargesController < ApplicationController
  before_action :authenticate_admin!, only: %i[index approve reprove show]
  before_action :find_id, only: %i[show approve reprove reprove_msn]
  def index
    @charges = Charge.all
  end

  def show
    @parcel = @charge.total_charge / @charge.qty_instalments
    @return_code = if @charge.reproved?
                     find_desapproval_code(@charge.return)
                   else
                     @charge.return
                   end
  end

  def approve
    if @charge.cupom_code != ''
      coupon = Coupon.find_by(code: @charge.cupom_code)

      return redirect_to reprove_charge_path(@charge), notice: 'Cupom inválido' if coupon.used?

      burn_coupon
    end

    update_charge_on_client_api(@charge, 'paid')
    update_charge_on_sales_api(@charge, 'concluded')
    @charge.approved!
    approve_code_gen
    redirect_to @charge
  end

  def update_charge_on_client_api(_charge, status)
    domain = Rails.configuration.apis['clients_api']
    response = Faraday.patch("#{domain}/api/v1/orders/payment") do |req|
      req.headers[:content_type] = 'application/json'
      req.body = { order_code: @charge.id_order, total_charge: @charge.total_charge, status: status }.to_json
    end
    return nil unless response.status == 200
  end

  def update_charge_on_sales_api(charge, status)
    domain = Rails.configuration.apis['sales_api']
    response = Faraday.patch("#{domain}/api/v1/orders/#{charge.id_order}/concluded") do |req|
      req.headers[:content_type] = 'application/json'
      req.body = { order_code: @charge.id_order, status: status }.to_json
    end
    return nil unless response.status == 200
  end

  def reprove
    update_charge_on_client_api(@charge, 'rejected')
    @charge.reproved!
    @return_codes = helpers.disapproval_codes
    @parcel = @charge.order_value / @charge.qty_instalments
  end

  def reprove_msn
    @charge.return = params[:return]
    @charge.save
    redirect_to @charge
  end

  def find_desapproval_code(code)
    return '' if code.nil?

    messages = helpers.disapproval_codes
    filtered = messages.filter { |m| m[1] == code }

    filtered[0][0]
  end

  def search
    @charges = Charge.where('client_eni like ?', "%#{params[:q]}%")
  end

  def approved
    @charges = Charge.approved
  end

  def reproved
    @charges = Charge.reproved
  end

  def pending
    @charges = Charge.pending
  end

  private

  def burn_coupon
    @coupon = Coupon.find_by(code: @charge.cupom_code)
    @coupon.used!
  end

  def approve_code_gen
    @charge.return = SecureRandom.hex(3)
    @charge.save
  end

  def find_id
    @charge = Charge.find(params[:id])
  end
end
