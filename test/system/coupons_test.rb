require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  test 'revoke cupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text "Cupom #{coupon.code} desabilitado com sucesso"
    assert_text "#{coupon.code} (desabilitado)"
    assert_no_link 'Desabilitar'
  end
end
