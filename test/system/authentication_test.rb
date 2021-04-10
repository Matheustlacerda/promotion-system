require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'matheus.tl@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'matheus.tl@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign in' do
    user = User.create!(email: 'matheus.tl@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    repetable_asserts(user)
    assert_link 'Sair'
    assert_no_link 'Entrar'
  end

  private

  def repetable_asserts(user)
    assert_text 'Login efetuado com sucesso!'
    assert_text user.email
    assert_current_path root_path
  end
end
