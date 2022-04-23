class CreateCardBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :card_banners do |t|
      t.string :name

      t.timestamps
    end
  end
end
