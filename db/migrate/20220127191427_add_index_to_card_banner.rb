class AddIndexToCardBanner < ActiveRecord::Migration[6.1]
  def change
    add_index :card_banners, :name, unique: true
  end
end
