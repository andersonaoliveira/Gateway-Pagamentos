require 'rails_helper'

describe 'Visitante registra usuário' do
  it 'com sucesso' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'admin@locaweb.com.br'
    fill_in 'Senha', with: 'admin1'
    fill_in 'Confirme sua senha', with: 'admin1'
    click_on 'Inscrever-se'
    expect(current_path).to eq root_path
    expect(page).to have_content('admin')
    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
  end

  it 'mas apresenta erro por email não pertencer ao domínio locaweb' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'admin@teste.com.br'
    fill_in 'Senha', with: 'admin1'
    fill_in 'Confirme sua senha', with: 'admin1'
    click_on 'Inscrever-se'
    expect(page).to have_content('E-mail Sistema exclusivo para administradores locaweb')
    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso.')
  end
end
