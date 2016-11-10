class UserTeam < ActiveRecord::Base
  # Associations
  has_many :user_team_users, inverse_of: :user_team
  has_many :users, through: :user_team_users, inverse_of: :user_teams
  has_many :current_users, class_name: 'User', foreign_key: 'current_team_id', inverse_of: :current_team

  has_many :productivity_goals, inverse_of: :user_team
  has_many :statistics, inverse_of: :user_team

  has_many :created_assignments, class_name: 'Assignment', foreign_key: 'creator_team_id', inverse_of: :creator_team
  has_many :recieved_assignments, class_name: 'Assignment', foreign_key: 'reciever_team_id', inverse_of: :reciever_team
end
