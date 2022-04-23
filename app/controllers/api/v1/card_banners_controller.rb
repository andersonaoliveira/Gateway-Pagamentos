class Api::V1::CardBannersController < Api::V1::ApiController
  def index
    card_banners = CardBanner.all
    render json: card_banners.as_json(except: %i[created_at updated_at]), status: :ok
  end

  def show
    card_banner = CardBanner.find(params[:id])
    render json: card_banner.as_json(
      except: %i[created_at updated_at discount percentual_tax max_tax name]
    ), status: :ok
  end
end
