class SalesController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_id, only: %i[show approve disapprove edit update disapprove_msg generate_coupons]

  def new
    @sale = Sale.new
    @product_groups = ProductGroup.all
  end

  def create
    @sale = Sale.new(params.require(:sale).permit(:name, :expiration_date, :discount, :max_value, :quantity,
                                                  :product_group_id, :admin_id))

    if @sale.save
      flash[:notice] = 'Promoção cadastrada com sucesso'
      redirect_to sale_path(@sale.id)
    else
      flash[:alert] = 'Promoção não pode ser cadastrada'
      @product_groups = ProductGroup.all
      render :new
    end
  end

  def show
    @product_group = ProductGroup.find(@sale.product_group_id)
    @admin = Admin.find(@sale.admin_id)
    @coupons = Coupon.where('sale_id like ?', @sale.id.to_s)
    @return_code = (find_disapproval_code(@sale.return_code) if @sale.disapproved?)
  end

  def index
    @sales = Sale.all
  end

  def approve
    @sale.update(status: :approved, approver: current_admin)
    redirect_to @sale
  end

  def disapprove
    @sale.update(status: :disapproved, approver: current_admin)
    @return_codes = helpers.disapproval_sale_codes
  end

  def disapprove_msg
    @sale.return_code = params[:return_code]
    @sale.save
    redirect_to @sale
  end

  def edit
    @product_groups = ProductGroup.all
  end

  def update
    sale_params = params.require(:sale).permit(:name, :expiration_date, :discount,
                                               :max_value, :quantity,
                                               :product_group_id, :admin_id)
    if @sale.update(sale_params)
      redirect_to sale_path(@sale.id), notice: 'Promoção atualizada com sucesso'
    else
      flash.now[:alert] = 'Erro! Não foi possível atualizar a promoção'
      render 'edit'
    end
  end

  def generate_coupons
    @sale.generate_coupons

    redirect_to @sale
  end

  def search
    @sales = Sale.where('name like ?', "%#{params[:q]}%")
  end

  def find_disapproval_code(code)
    return '' if code.nil?

    messages = helpers.disapproval_sale_codes
    filtered = messages.filter { |m| m[1] == code }

    filtered[0][0]
  end

  private

  def find_id
    @sale = Sale.find(params['id'])
  end
end
