# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  #let RoR handle password stuff
  has_secure_password


  #Antes de guardar el usuario, pasa el email a minusculas
  before_save { |user| user.email = email.downcase}

  #Valida que exista un nombre y que la longitud sea menor o igual a 50
  validates :name, :presence => true, :length => { maximum: 50 }

  #Regex para emails correctos, valida que exista un email, que tenga el formato
  #correcto y que sea unico independientemente de mayusculas o minusculas
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false} 

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
