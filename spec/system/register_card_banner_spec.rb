require 'rails_helper'

describe 'User register card banner' do
  it 'through a link on the navigation bar' do
    admin = create(:admin)
    login_as(admin)
    visit root_path
    click_on 'Cadastrar Bandeira'
    expect(current_path).to eq new_card_banner_path
  end

  it 'and view form successfully' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Cadastrar Bandeiras'

    expect(page).to have_content 'Cadastrar Bandeira'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Ícone'
    expect(page).to have_field 'Taxa da bandeira'
    expect(page).to have_field 'Valor máximo da taxa'
    expect(page).to have_field 'Número máximo de parcelas'
    expect(page).to have_field 'Desconto para compras à vista'
    expect(page).to have_button 'Salvar'
  end

  it 'successfully' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Cadastrar Bandeiras'

    fill_in 'Nome', with: 'Visa'
    attach_file 'Ícone', Rails.root.join('spec', 'support', 'icons', 'visa.png')
    fill_in 'Taxa da bandeira', with: '10'
    fill_in 'Valor máximo da taxa', with: '10'
    fill_in 'Número máximo de parcelas', with: '12'
    fill_in 'Desconto para compras à vista', with: '8'
    click_on 'Salvar'

    expect(page).to have_content('Bandeira cadastrada com sucesso!')
    expect(page).to have_content('Visa')
    expect(page).to have_css('img[src*="visa.png"]')
    expect(page).to have_content('10,0%')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('12')
    expect(page).to have_content('8,0%')
  end

  it 'unsuccessfully' do
    admin = create(:admin)

    login_as(admin)

    visit root_path
    click_on 'Cadastrar Bandeiras'
    click_on 'Salvar'

    expect(current_path).to eq card_banners_path
    expect(page).to have_content('Bandeira não pode ser cadastrada!')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Número máximo de parcelas não pode ficar em branco')
    expect(page).to have_content('Percentual de desconto para pagamento à vista não pode ficar em branco')
    expect(page).to have_content('Taxa percentual não pode ficar em branco')
    expect(page).to have_content('Valor máximo da taxa em reais não pode ficar em branco')
  end
end
