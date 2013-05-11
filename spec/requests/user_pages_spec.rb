require 'spec_helper'

describe "UserPages" do
  
  subject { page }

  describe "pagina de registro" do
  	before { visit registro_path }

    let(:submit) { "Crear mi cuenta"}

    describe "con informacion invalida" do
      it "no debe crear al usuario" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "con informacion valida" do
      before do
        fill_in "Nombre",      with: "Usuario Ejemplo"
        fill_in "Email",       with: "usuario@ejemplo.com"
        fill_in "Password",    with: "lalala"
        fill_in "Confirma Pass", with: "lalala"
      end

      it "should create a user" do 
        expect { click_button submit }.to change(User, :count).by 1
      end
    end

  	it { should have_selector('h1', text: "Registrate") }
  	it { should have_selector('title', text: "iTuits | Registro" )}
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name)}
  end

end
