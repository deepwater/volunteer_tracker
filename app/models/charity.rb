class Charity < ActiveRecord::Base

has_many :user_charities
has_many :users, through: :user_charities
end
