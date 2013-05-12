# encoding: UTF-8
require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "pagina inicio de sesion" do
		before { visit login_path }

		it { should have_selector('h1', text: 'Inicia sesión') }
		it { should have_selector('title', text: 'Log in')}
	end

	describe "login" do
		before { visit login_path }

		describe "con informacion invalida" do
			before { click_button "Iniciar" }

			it { should have_selector('title', text: 'Log in') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid')}

			describe "despues de visitar otra pagina" do
				before { click_link "Inicio"}
				it { should_not have_selector('div.alert.alert-error')}
			end

		end

		describe "con informacion valida" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Iniciar"
			end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Perfil', href: user_path(user)) }
			it { should have_link('Salir', href: logout_path) }
			it { should_not have_link('Log in', href: login_path) }

			describe "despues de terminar sesion" do
				before { click_link "Salir"}
				it { should have_link('Iniciar sesion')}
			end
		end
	end
end
