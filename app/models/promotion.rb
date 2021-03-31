class Promotion < ApplicationRecord
  belongs_to :user
  has_many :coupons, dependent: :delete_all
  has_one :promotion_approval


  validates :name, :code, :discount_rate, :coupon_quantity, 
            :expiration_date, presence: true
  validates :name,:code, 
            :discount_rate, 
            :coupon_quantity, 
            :expiration_date, on: :update,
            presence: true
  validates :code, :name, uniqueness: true
  def self.search(query)
    text =
    %w[name code description]
      .map { |field| "#{field} LIKE :query" }
      .join (' OR ')
    where(text, query: "%#{query}%")
  end

  def approved?
    promotion_approval.present?
  end
end
