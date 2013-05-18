# == Schema Information
#
# Table name: minituits
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Minituit do

  let(:user) { FactoryGirl.create(:user) }
  #Codigo incorrecto: cada minituit debe estar relacionado a un user
  #before do
  #  @minituit = Minituit.new(content: "Lorem ipsum", user_id: user.id)
  #end

  #Codigo correcto
  before { @minituit = user.minituits.build(content: "Lorem ipsum") }

  subject { @minituit }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it(:user) { should be_valid }

  it { should be_valid }

  describe "cuando no hay user_id" do
    before { @minituit.user_id = nil }
    it { should_not be_valid }
  end

  describe "con contenido en blanco" do
    before { @minituit.content = " "}
    it { should_not be_valid }
  end

  describe "con contenido muy largo" do
    before { @minituit.content = "a"*151 }
    it { should_not be_valid }
  end

  describe "atributos accesibles" do
    it "no debe haber acceso a user_id" do
      expect do
        Minituit.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
