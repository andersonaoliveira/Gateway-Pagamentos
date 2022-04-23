class AddColumnsToCardBanner < ActiveRecord::Migration[6.1]
  def change
    add_column :card_banners, :max_instalments, :integer
    add_column :card_banners, :discount, :float
    add_column :card_banners, :percentual_tax, :float
    add_column :card_banners, :max_tax, :float
  end
end
