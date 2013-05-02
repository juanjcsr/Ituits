require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
  	it "should have the content 'iTuits'" do
  		visit '/static_pages/home'
  		page.should have_content('iTuits')
  	end

    it "should have the base title" do
      visit '/static_pages/home'
      page.should have_selector 'title', :text => 'iTuits'
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      page.should_not have_selector 'title', :text => '| Home'
    end
  end

  describe "Help page" do
  	it "should have the content 'Ayuda'" do
  		visit '/static_pages/help'
  		page.should have_content 'Ayuda'
  	end

    it "should have the title 'Ayuda'" do
      visit '/static_pages/help'
      page.should have_selector 'title', :text => 'iTuits | Ayuda'
    end
  end

  describe "Acerca de" do
    it "should have the content 'Acerca De'" do
      visit '/static_pages/about'
      page.should have_content 'Acerca De'
    end

    it "should have the title 'About'" do
      visit '/static_pages/about'
      page.should have_selector 'title', :text => 'iTuits | About'
    end
  end
end
