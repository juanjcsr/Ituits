class ApplicationController < ActionController::Base
  protect_from_forgery
  #Permite al modulo de Session estar disponible en toda la app
  include SessionsHelper

  #Forzar fin de sesion para prevenir ataques CSRF
  def handle_unverified_request
  	log_out
  	super
  end


end
