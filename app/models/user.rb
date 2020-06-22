# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :requests, foreign_key: 'requester_id', class_name: 'Request'
  has_many :offers, foreign_key: 'helper_id', class_name: 'Offer'
  has_many :quests, foreign_key: 'helper_id', class_name: 'Request'

  def reward_karma_points(points)
    self.update_attribute(:karma_points, self.karma_points + points)
  end
end
