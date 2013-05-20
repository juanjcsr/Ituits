require 'spec_helper'

describe "UserPages" do
  
  subject { page }

  describe "index" do
    before do
      log_in FactoryGirl.create(:user)
      
      visit users_path
    end

    it { should have_selector('title', text: "Todos los usuarios")}
    it { should have_selector('h1', text: "Todos los usuarios")}

    it "debe mostrar a todos los usuarios" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do 
        User.paginate(page: 1, per_page: 10).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "links para borrar" do
      it { should_not have_link('borrar') }

      describe "como un usuario admnin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          log_in admin
          visit users_path
        end

        it { should have_link('borrar', href: user_path(User.first)) }
        it "debe poder borrar a otro usuario" do
          expect { click_link('borrar') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('borrar', href: user_path(admin)) }
      end
    end
  end

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
    #minituits! 
    #let! (let BANG) permite crear objetos en el momento (let se evalua de forma lazy, 
    # (hasta que se evalua), entonces let! permite crearlos en este momento
    let!(:mt1) { FactoryGirl.create(:minituit, user: user, content: "Foo") }
    let!(:mt2) { FactoryGirl.create(:minituit, user: user, content: "Bar") }

  	before do
      visit user_path(user) 
    end

  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name)}

    describe "minituits" do
      it { should have_content(mt1.content) }
      it { should have_content(mt2.content) }
      it { should have_content(user.minituits.count) }
    end
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
