class Event < ActiveRecord::Base
  attr_accessible :name, :assigned_to, :organisation_id, :route_type, :address_line_1, :address_line_2,
                  :city, :state, :zip, :other, :day_of_start, :day_of_finish, :days_for_setup,
                  :days_for_tear_down

  has_many :days, dependent: :destroy
  belongs_to :user, primary_key: :assigned_to, foreign_key: :id
  belongs_to :organisation

  validates :name, :route_type, :day_of_start, :day_of_finish, :organisation_id, presence: true
end
