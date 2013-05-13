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

  describe "editar" do
    let(:user) { FactoryGirl.create(:user)}
    before do
      log_in user
      visit edit_user_path(user)
    end

    describe "pagina" do
      it { should have_selector('h1', text: "Modifica tu perfil") }
      it { should have_selector('title', text: "Editar usuario") }
      it { should have_link('cambiar', href: 'http://gravatar.com/emails')}
    end

    describe "con informacion invalida" do
      before { click_button "Guardar cambios" }

      it { should have_content('error') }
    end

    describe "con informacion valida" do
      let(:new_name) { "Nuevo nombre" }
      let(:new_email) { "nuevo@email.com" }

      before do
        fill_in "Nombre",      with: new_name
        fill_in "Email",       with: new_email
        fill_in "Password",    with: user.password
        fill_in "Confirma password", with: user.password
        click_button "Guardar cambios"
      end

      it { should have_selector('title', text: new_name )}
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Salir', href: logout_path) }

      #'reload' permite recargar el parametro de la DB
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }

    end
  end

end
