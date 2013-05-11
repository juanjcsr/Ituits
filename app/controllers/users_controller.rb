class UsersController < ApplicationController
  #GET
  def new
  	@user = User.new
  end

  #POST
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		#Handle a successful save.
      flash[:success] = "Bienvenido a iTuits"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  #GET
  def show
  	@user = User.find(params[:id])
  end
end
