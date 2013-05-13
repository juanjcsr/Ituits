class UsersController < ApplicationController
  #realiza metodos antes de las acciones del controlador
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :usuario_correcto, only: [:edit, :update]

  #GET
  def new
  	@user = User.new
  end

  #POST
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		#Handle a successful save.
      log_in @user
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

  #GET
  def edit
  end

  #POST
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #handle a successful update.
      flash[:success] = "Perfil actualizado"
      log_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def signed_in_user
      redirect_to login_url, notice: "Registrate primero" unless signed_in?
    end

    def usuario_correcto
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
