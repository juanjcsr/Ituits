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

			before { log_in user }

			it { should have_selector('title', text: user.name) }
			it { should have_link('Perfil', href: user_path(user)) }
			it { should have_link('Salir', href: logout_path) }
			it { should have_link('Ajustes', href: edit_user_path(user))}
			it { should_not have_link('Log in', href: login_path) }

			describe "despues de terminar sesion" do
				before { click_link "Salir"}
				it { should have_link('Iniciar sesion')}
			end
		end
	end

	describe "autorizacion" do

		describe "para usuarios sin sesion" do
			let(:user) { FactoryGirl.create(:user) }

			describe "en el controlador Users" do
				describe "visitando la pagina de edicion" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Log in') }
				end

				describe "realizando una actualizacion" do
					before { put user_path(user) }
					specify { response.should redirect_to(login_path) }
				end

				describe "visitando el indice de usuarios" do
					before { visit users_path }
					it { should have_selector('title', text: 'Log in')}
				end
			end

			describe "en el controlador de Minituits" do
				describe "realizando la accion crear" do
					before { post minituits_path }
					specify { response.should redirect_to(login_path) }
				end

				describe "realizando la accion de destruir" do
					before { delete minituit_path(FactoryGirl.create(:minituit)) }
					specify { response.should redirect_to(login_path) }
				end
			end

			describe "al intentar visitar una pagina protegida" do
				before do
					visit edit_user_path(user)
					fill_in "Email",  with: user.email
					fill_in "Password", with: user.password
					click_button "Iniciar"
				end

				describe "despues de iniciar sesion" do
					it "debe mostrarse la pagina protegida" do
						page.should have_selector('title', text: 'Editar usuario')
					end
				end
			end
		end

		describe "para usuarios incorrects" do
			let(:user) { FactoryGirl.create(:user) }
			let(:mal_usuario) { FactoryGirl.create(:user, email: "mal@usuario.com") }
			before { log_in user }

			describe "visitando pagina Users#edit" do
				before { visit edit_user_path(mal_usuario) }
				it { should_not have_selector('title', text: "Editar usuario") }
			end

			describe "realizar una accion PUT hacia Users#put" do
				before { put user_path(mal_usuario) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end
