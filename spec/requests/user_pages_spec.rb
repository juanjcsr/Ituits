require 'spec_helper'

describe "UserPages" do
  
  subject { page }

  describe "pagina de registro" do
  	before { visit registro_path }

  	it { should have_selector('h1', text: "Registrate") }
  	it { should have_selector('title', text: "iTuits | Registro" )}
  end

end
