class Event < ActiveRecord::Base
  attr_accessible :name, :assigned_to, :route_type, :address_line_1, :address_line_2,
                  :city, :state, :zip, :other

  has_many :days, dependent: :destroy
  belongs_to :user, primary_key: :assigned_to, foreign_key: :id

  validates :name, :route_type, presence: true

end
