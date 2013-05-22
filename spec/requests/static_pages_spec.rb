require 'spec_helper'

describe "StaticPages" do
  subject { page }
  
  describe "Home page" do
    before { visit root_path }
  	it { should have_selector('h1', :text => 'Bienvenido a iTuits')}

    it "should have the base title" do
      page.should have_selector 'title', :text => 'iTuits'
    end

    it "should not have a custom page title" do
      page.should_not have_selector 'title', :text => '| Home'
    end

    describe "para usuarios con sesion" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:minituit, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:minituit, user: user, content: "Dolor sit amet")
        log_in user
        visit root_path
      end

      it "debe mostrar el feed del usuario" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "contador de follows/following" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
  	it "should have the content 'Ayuda'" do
  		page.should have_content 'Ayuda'
  	end

    it "should have the title 'Ayuda'" do
      page.should have_selector 'title', :text => 'iTuits | Ayuda'
    end
  end

  describe "Acerca de" do
    before { visit about_path }
    it "should have the content 'Acerca De'" do
      page.should have_content 'Acerca De'
    end


    it "should have the title 'About'" do
      page.should have_selector 'title', :text => 'iTuits | About'
    end
  end

  describe "Contacto" do
    before {visit contact_path }
    it "should have the h1 'Contacto'" do
      page.should have_selector('h1', text: 'Contacto')
    end

    it "should have the title 'Contacto'" do
      page.should have_selector('title', :text => 'iTuits | Contacto' )
    end
  end
end
