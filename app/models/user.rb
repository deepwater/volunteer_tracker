# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  tshirt_size            :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  cell_phone             :string(255)
#  home_phone             :string(255)
#  secondary_email        :text
#

class User < ActiveRecord::Base

  ROLES = %w[volunteer volunteer_manager department_assistant department_manager event_administrator]
  TSHIRT_SIZES = %w[S M L XL XXL XXXL]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :tshirt_size, :role, :cell_phone, :home_phone, :user_id, :department_block_id, :secondary_email

  has_many :user_availabilities, dependent: :destroy

  has_many :user_schedules, dependent: :destroy
  has_many :department_blocks, :through => :user_schedules

  has_many :user_charities, dependent: :destroy
  has_many :charities, :through => :user_charities

  has_one :department_manager
  has_one :lt_department_manager
  has_one :volunteer_manager

  before_save :default_values

  def default_values
    self.role ||= 'volunteer'
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def full_name 
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end
end
