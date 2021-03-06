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

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :username
  #let RoR handle password stuff (authenticate methods)
  has_secure_password

  #Relacion de usuarios a minituits, destruir los minituits dependientes
  has_many :minituits, dependent: :destroy
  #Relacion de "relaciones"
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower


  #Antes de guardar el usuario, pasa el email a minusculas
  before_save { |user| user.email = email.downcase}
  #antes de guardar hay que crear un token para guardar al usuario 
  before_save :create_remember_token

  #Valida que exista un nombre y que la longitud sea menor o igual a 50
  validates :name, :presence => true, :length => { maximum: 50 }

  #Regex para emails correctos, valida que exista un email, que tenga el formato
  #correcto y que sea unico independientemente de mayusculas o minusculas
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\w/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false} 

  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    #Minituit.where("user_id = ?", id)
    Minituit.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def to_param
    username
  end
  
  def self.find_by_param(input)
    find_by_username(input)
  end
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
