class SessionsController < ApplicationController

	def new
	end

	def create
		#:session es un hash nested con info sobre el email y el pass
		user = User.find_by_email(params[:session][:email].downcase)
		if (user && user.authenticate(params[:session][:password]))
			#inicia sesion con el usuario y redirigelo a la pagina user show (su perfil)
			log_in user
			redirect_back_or root_path
		else
			#en caso de error en sesion
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end
end
