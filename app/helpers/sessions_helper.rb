module SessionsHelper
	def log_in(user)
		#cookies.permanent[:remember_token] = user.remember_token
		#Usar sesion en lugar de cookies
		session[:user_id] = user.id
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

	def current_user
		#@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		@current_user ||= User.find_by_id(session[:user_id])
	end

	def log_out
		self.current_user = nil
		#cookies.delete(:remember_token)
		session[:user_id] = nil
	end
end
