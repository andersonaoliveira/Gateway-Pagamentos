require 'rails_helper'

describe 'User edit a card banner' do
  it 'visitor is unable to access the form' do
    card_banner = create(:card_banner)

    visit edit_card_banner_path(card_banner.id)

    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'with success' do
    admin = create(:admin)
    card_banner = create(:card_banner)

    login_as(admin)
    visit edit_card_banner_path(card_banner.id)

    fill_in 'Nome', with: 'Master'
    attach_file 'Ícone', Rails.root.join('spec', 'support', 'icons', 'visa.png')
    fill_in 'Taxa cobrada pela bandeira', with: '10'
    fill_in 'Valor máximo da taxa', with: '10'
    fill_in 'Número máximo de parcelas', with: '12'
    fill_in 'Desconto para compras à vista', with: '8'
    click_on 'Salvar'

    expect(page).to have_content('Bandeira editada com sucesso!')
    expect(page).to have_content 'Master'
    expect(page).to have_css('img[src*="visa.png"]')
    expect(page).to have_content('10,0%')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('12')
    expect(page).to have_content('8,0%')
  end

  it 'without success' do
    admin = create(:admin)
    card_banner = create(:card_banner)

    login_as(admin)
    visit edit_card_banner_path(card_banner.id)

    fill_in 'Nome', with: ''
    attach_file 'Ícone', Rails.root.join('spec', 'support', 'icons', 'visa.png')
    fill_in 'Taxa cobrada pela bandeira', with: '10'
    fill_in 'Valor máximo da taxa', with: '10'
    fill_in 'Número máximo de parcelas', with: '12'
    fill_in 'Desconto para compras à vista', with: '8'
    click_on 'Salvar'

    expect(page).to have_content('Erro! Não foi possível editar a bandeira!')
    expect(page).to have_content('Nome não pode ficar em branco')
  end
end
