class User < ActiveRecord::Base

  ROLES = %w[event_admin event_coordinator lt_coordinator volunteer_coordinator volunteer]
  TSHIRT_SIZES = %w[S M L XL XXL XXXL]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :tshirt_size, :role

  has_many :user_availabilities
  has_many :user_charities
  has_many :charities, :through => :user_charities

  before_save :default_values

  def default_values
    self.role ||= 'volunteer'
  end
end
