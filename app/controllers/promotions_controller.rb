class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit 
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id]) 
    if update_promotions_and_cupons
      flash[:notice] = 'Promoção editada com sucesso'
      redirect_to @promotion
    else
      render :edit
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    flash[:notice] = "Promoção #{@promotion.name} apagada! "
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    @promotion = Promotion.find(params[:id]) 
    create_cupons_for_promotion   
    flash[:notice] = 'Cupons gerados com sucesso'
    redirect_to @promotion
  end  

  private 
    def promotion_params
      params
        .require(:promotion)
        .permit(:name, :expiration_date, :description,
                :discount_rate, :code, :coupon_quantity)
    end

    def update_promotions_and_cupons
      @promotion.update(promotion_params)
  
      if @promotion.coupons.any?
        @promotion.coupons.destroy_all
        create_cupons_for_promotion
      end
      
      true
    end    

    def create_cupons_for_promotion
      (1..@promotion.coupon_quantity).each do |number|
        Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
      end
    end
end