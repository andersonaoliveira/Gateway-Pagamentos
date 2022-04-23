class CardBannersController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create edit update index]
  before_action :find_id, only: %i[show edit update]

  def new
    @card_banner = CardBanner.new
  end

  def create
    card_banner_params = params.require(:card_banner).permit(:name, :icon, :max_instalments, :discount, :percentual_tax,
                                                             :max_tax)
    @card_banner = CardBanner.new(card_banner_params)
    if @card_banner.save
      redirect_to @card_banner, notice: 'Bandeira cadastrada com sucesso!'
    else
      flash.now[:alert] = 'Bandeira não pode ser cadastrada!'
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    card_banner_params = params.require(:card_banner).permit(:name, :icon, :max_instalments, :discount, :percentual_tax,
                                                             :max_tax)
    @card_banner.update(card_banner_params)
    if @card_banner.save
      redirect_to @card_banner, notice: 'Bandeira editada com sucesso!'
    else
      flash.now[:alert] = 'Erro! Não foi possível editar a bandeira!'
      render 'edit'
    end
  end

  def index
    @card_banners = CardBanner.all
  end

  def disable
    card_banner = CardBanner.find(params[:id])
    card_banner.inactive!
    redirect_to card_banner
  end

  def activate
    card_banner = CardBanner.find(params[:id])
    card_banner.active!
    redirect_to card_banner
  end

  private

  def find_id
    @card_banner = CardBanner.find(params[:id])
  end
end
