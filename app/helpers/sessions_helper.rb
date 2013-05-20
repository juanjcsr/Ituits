module SessionsHelper
	def log_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		#Usar sesion en lugar de cookies
		#session[:user_id] = user.id
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in_user
      #Para almacenar la ruta de redireccion en caso de no estar en sesion
  	unless signed_in?
    	store_last_location
    	redirect_to login_url, notice: "Inicia sesion primero"
  	end
  end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		#@current_user ||= User.find_by_id(session[:user_id])
	end

	def log_out
		self.current_user = nil
		cookies.delete(:remember_token)
		#session[:user_id] = nil
	end

	#Metodos para guardar la ubicacion para los redirects
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_last_location
		session[:return_to] = request.url
	end
end
