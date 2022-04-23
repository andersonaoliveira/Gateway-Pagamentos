require 'rails_helper'

describe 'Admim views registered card banners list' do
  it 'through a link on the navigation bar' do
    admin = create(:admin)
    login_as(admin)
    visit root_path
    click_on 'Visualizar Bandeiras'
    expect(current_path).to eq card_banners_path
  end

  it 'but there are no banners registered' do
    admin = create(:admin)

    login_as admin
    visit root_path
    click_on 'Visualizar Bandeiras'

    expect(page).to have_css 'h1', text: 'BANDEIRAS DE CARTÃO'
    expect(page).to have_content 'Não existem bandeiras cadastradas no sistema'
  end

  it 'successfully' do
    admin = create(:admin)
    create :card_banner
    card_banner = create :card_banner, name: 'Mastercard'
    card_banner.inactive!

    login_as admin

    visit root_path
    click_on 'Visualizar Bandeiras'

    expect(page).to have_css 'h1', text: 'BANDEIRAS DE CARTÃO'
    expect(page).to have_content 'Bandeira'
    expect(page).to have_content 'Status'
    expect(page).to have_css('img[src*="visa.png"]')
    expect(page).to have_content 'Ativada'
    expect(page).to have_css('img[src*="mastercard.png"]')
    expect(page).to have_content 'Desativada'
  end
end
