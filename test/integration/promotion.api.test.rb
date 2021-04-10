require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show cupon' do
    coupon = Fabricate(:coupon, code: 'NATAL10-0001')

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response 200
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.discount_rate.to_s, body[:discount_rate]
  end

  test 'cupon not found' do
    get "/api/v1/coupons/0", as: :json

    assert_response 404
  end

  test 'route invalid without json header' do 
    get "/api/v1/coupons/0", as: :json

    assert_response 404
  end

  test 'show cupon disable' do
    coupon = Fabricate(:coupon, status: :disabled)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :not_found
  end
end