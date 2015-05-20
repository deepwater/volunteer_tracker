class Event < ActiveRecord::Base
  resourcify

  has_many :days, dependent: :destroy
  belongs_to :user, primary_key: :assigned_to, foreign_key: :id
  belongs_to :organisation

  validates :name, :route_type, :day_of_start, :day_of_finish, :organisation_id, presence: true
end
