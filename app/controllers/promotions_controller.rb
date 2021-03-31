class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[show generate_coupons 
                                         destroy update edit approve]

  def index
    @promotions = 
    if params[:q]
      Promotion.search(params[:q])
    else
    Promotion.all
    end
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = current_user.promotions.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit 
    @user = current_user
  end

  def update
    if update_promotions_and_cupons
      flash[:notice] = 'Promoção editada com sucesso'
      redirect_to @promotion
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = "Promoção #{@promotion.name} apagada! "
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    create_cupons_for_promotion   
    redirect_to @promotion, notice: t('.success')
  end

  def search
    @promotions = Promotion.search(params[:q])
    render :index
  end

  def approve
    PromotionApproval.create!(promotion: @promotion, user: current_user)
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
  end

  private 
    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params
        .require(:promotion)
        .permit(:name, :expiration_date, :description,
                :discount_rate, :code, :coupon_quantity)
    end

    def update_promotions_and_cupons
      if @promotion.update(promotion_params)
  
        if @promotion.coupons.any?
          @promotion.coupons.destroy_all
          create_cupons_for_promotion
        end
        true
      else
        false
      end
    end

    def create_cupons_for_promotion
      (1..@promotion.coupon_quantity).each do |number|
        Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
      end
    end
end