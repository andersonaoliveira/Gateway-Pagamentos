class HomeController < ApplicationController
  before_action :authenticate_admin!, only: [:index]

  def index
    @api_produtos = api_check(Rails.configuration.apis['products_api'])
    @api_vendas = api_check(Rails.configuration.apis['sales_api'])
    @api_clientes = api_check(Rails.configuration.apis['clients_api'])
    @sales = Sale.pending.first(3)
    @charges = Charge.pending.first(3)
  end

  private

  def api_check(path)
    Faraday.get(path)
    true
  rescue StandardError
    false
  end
end
