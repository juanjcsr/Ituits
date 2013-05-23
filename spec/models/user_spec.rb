# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "JC Ejemplo", username: "jjuanchow", email: "email@ejemplo.com", password: "foobar", password_confirmation: "foobar") }


  subject { @user }

  it { should respond_to( :name ) }
  it { should respond_to( :email ) }
  it { should respond_to( :password_digest )}
  it { should respond_to( :password )}
  it { should respond_to( :password_confirmation )}
  it { should respond_to( :remember_token) }
  it { should respond_to( :admin) }
  it { should respond_to( :authenticate )}
  it { should respond_to( :username) }

  it { should respond_to( :minituits) }
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  it { should be_valid }
  it { should_not be_admin}

  describe "con el atributo admin como verdadero" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }   
  end

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " "}
  	it { should_not be_valid }
  end

  describe "when username is not present" do
    before { @user.username = " "}
    it { should_not be_valid }
  end



  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it {should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		direcciones = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
  		direcciones.each do |invalid_address| 
  			@user.email = invalid_address
  			@user.should_not be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		direcciones = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		direcciones.each do |valid_address|
  			@user.email = valid_address
  			@user.should be_valid
  		end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		usuario_con_mismo_email = @user.dup
  		usuario_con_mismo_email.email = @user.email.upcase
  		usuario_con_mismo_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when username is already taken" do
    before do
      usuario_con_mismo_username = @user.dup
      usuario_con_mismo_username.username = @user.username.upcase
      usuario_con_mismo_username.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
  	before { @user.password = @user.password_confirmation = " " }
  	it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
  	before { @user.password_confirmation = nil }
  	it { should_not be_valid }
  end

  describe "return value of authenticated method" do
  	before { @user.save }
  	let(:found_user) { User.find_by_email( @user.email )}

  	describe "with valid password" do
  		it { should == found_user.authenticate( @user.password )}
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  		it {should_not == user_for_invalid_password }
  		specify { user_for_invalid_password.should be_false }
  	end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
  	end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "recordar token" do
    before { @user.save }
    its(:remember_token) {should_not be_blank}
  end

  describe "asociaciones de minituits" do
    
    before { @user.save }
    let!(:minituit_viejo) do
      FactoryGirl.create(:minituit, user: @user, created_at: 1.day.ago)
    end

    let!(:minituit_nuevo) do
      FactoryGirl.create(:minituit, user: @user, created_at: 1.hour.ago)
    end

    it "debe tener a los minituits en el orden correcto" do
      @user.minituits.should == [minituit_nuevo, minituit_viejo]
    end

    it "debe destruir a sus minituits asociados" do
      minituits = @user.minituits.dup
      @user.destroy
      minituits.should_not be_empty
      minituits.each do |minituit|
        Minituit.find_by_id(minituit.id).should be_nil
      end
    end

    describe "status" do
      let(:minituit_sin_seguir) do
        FactoryGirl.create(:minituit, user: FactoryGirl.create(:user))
      end

      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.minituits.create!(content: "Lorem ipsum")}
      end

      its(:feed) { should include(minituit_nuevo) }
      its(:feed) { should include(minituit_viejo) }
      its(:feed) {should_not include(minituit_sin_seguir)}
      its(:feed) do
        followed_user.minituits.each do | ituit |
          should include(ituit)
        end
      end
    end

  end

  describe "siguiendo" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "usuario seguido" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "y dejando de seguir" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user)}
    end
  end

end
