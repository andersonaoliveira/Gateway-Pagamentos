require 'rails_helper'

describe 'Admin faz login' do
  it 'com sucesso' do
    create(:admin)
    visit root_path
    fill_in 'Email', with: 'admin@locaweb.com.br'
    fill_in 'Senha', with: 'admin1'
    click_on 'Entrar'
    expect(current_path).to eq root_path
    expect(page).to have_content('admin')
    expect(page).to have_content('Login efetuado com sucesso.')
  end

  it 'e faz logout' do
    create(:admin)
    visit root_path
    fill_in 'Email', with: 'admin@locaweb.com.br'
    fill_in 'Senha', with: 'admin1'
    click_on 'Entrar'
    click_on(class: 'ls-ico-user')
    click_on 'Sair'
    expect(page).not_to have_content('admin')
  end

  it 'mas erra a senha' do
    create(:admin)
    visit root_path
    fill_in 'Email', with: 'admin@locaweb.com.br'
    fill_in 'Senha', with: 'senha_errada'
    click_on 'Entrar'
    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).not_to have_content('admin')
  end
end
