class CouponsController < ApplicationController
  before_action :authenticate_admin!

  def search
    @coupons = Coupon.all.where('code like ?', "%#{params[:query]}%")
    @coupon = Coupon.where('code like ?', "%#{params[:query]}%")
  end
end
