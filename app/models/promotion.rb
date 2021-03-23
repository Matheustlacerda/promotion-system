class Promotion < ApplicationRecord
    has_many :coupons, dependent: :delete_all

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: true
    validates :name,:code, 
              :discount_rate, 
              :coupon_quantity, 
              :expiration_date, on: :update,
              presence: true
    validates :code, :name, uniqueness: true
end
