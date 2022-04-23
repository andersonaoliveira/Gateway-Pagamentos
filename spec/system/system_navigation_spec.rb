# frozen_string_literal: true

require 'rails_helper'

describe 'Admin navigates' do
  it 'dont see the menu' do
    visit root_path
    expect(page).not_to have_css('nav', text: 'Página Inicial')
    expect(page).not_to have_css('nav', text: 'Cadastrar Bandeiras')
    expect(page).not_to have_css('nav', text: 'Visualizar Bandeirass')
  end

  it 'and see the menu' do
    admin = create(:admin)
    login_as(admin)
    visit root_path
    expect(page).to have_css('nav', text: 'Página Inicial')
    expect(page).to have_css('nav', text: 'Cadastrar Bandeira')
    expect(page).to have_css('nav', text: 'Visualizar Bandeiras')
    expect(page).to have_link('Página Inicial', href: root_path)
  end
end
