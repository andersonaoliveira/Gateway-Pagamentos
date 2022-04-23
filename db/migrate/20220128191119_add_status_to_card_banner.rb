class AddStatusToCardBanner < ActiveRecord::Migration[6.1]
  def change
    add_column :card_banners, :status, :integer, default: 1
  end
end
