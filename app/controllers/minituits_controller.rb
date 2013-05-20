class MinituitsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy

  def create
    @minituit = current_user.minituits.build(params[:minituit])
    if @minituit.save
      flash[:success] = "iTuit creado"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @minituit.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @minituit = current_user.minituits.find_by_id(params[:id])
    rescue
      redirect_to root_url if @minituit.nil?
    end
end