require 'spec_helper'

describe "MinituitPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { log_in user }

  describe "creacion de minituit" do
    before { visit root_path }

    describe "con informacion invalida" do 
      it "no debe crear un minituit" do
        expect { click_button "Tuit" }.not_to change(Minituit, :count)
      end

      describe "mensajes de error" do
        before { click_button "Tuit" }
        it { should have_content('error') }
      end
    end

    describe "con informacion valida" do
      
      before { fill_in "minituit_content", with: "Lorem ipsum" }
      it "debe crear un minituit" do
        expect { click_button "Tuit" }.to change(Minituit, :count).by(1)
      end
    end
  end
end
