class Promotion < ApplicationRecord
    has_many :coupons, dependent: :delete_all

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: { message: 'não pode ficar em branco' }
    validates :name,:code, 
              :discount_rate, 
              :coupon_quantity, 
              :expiration_date, on: :update,
              presence: {message: 'não pode ficar em branco'}
    validates :code, :name, uniqueness: { message: 'deve ser único' }
end
