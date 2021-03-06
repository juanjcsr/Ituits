class UsersController < ApplicationController
  #realiza metodos antes de las acciones del controlador
  before_filter :signed_in_user, 
                only: [:edit, :update, :index, :destroy, :following, :followers]
  before_filter :usuario_correcto, only: [:edit, :update]
  before_filter :usuario_admin, only: :destroy

  #GET
  def new
  	@user = User.new
  end

  #GET
  def index
    #@users = User.all
    #Paginar usuarios
    @users = User.paginate(page: params[:page], per_page: 10)
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
  	@user = User.find_by_param(params[:id])
    @minituits = @user.minituits.paginate(page: params[:page])
  end

  #GET
  def edit
  end

  #POST
  def update
    @user = User.find_by_param(params[:id])
    if @user.update_attributes(params[:user])
      #handle a successful update.
      flash[:success] = "Perfil actualizado"
      log_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  #GET
  def destroy
    User.find_by_param(params[:id]).destroy
    flash[:success] = "Usuario eliminado"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find_by_param(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_param(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def signed_in_user
      #Para almacenar la ruta de redireccion en caso de no estar en sesion
      unless signed_in?
        store_last_location
        redirect_to login_url, notice: "Inicia sesion primero"
      end
    end

    def usuario_correcto
      @user = User.find_by_param(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def usuario_admin
      redirect_to(root_path) unless  current_user.admin?
    end
end
