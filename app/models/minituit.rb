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

class Minituit < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'minituits.created_at DESC'

  def self.from_users_followed_by(user)
    #Metodo proporcionado por Rails similar a :
    #                   user.followed_users.map { |u| u.id }
    # followed_user_ids = user.followed_user_ids  
    #Se usa un subselect en el query para que sea mas eficiente el query
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id",
    #      followed_users_ids: followed_users_ids, user_id: user)
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end 
end
