class User < ActiveRecord::Base
  rolify

  TSHIRT_SIZES = %w[S M L XL XXL XXXL]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, 
                  :last_name, :tshirt_size, :role, :cell_phone, :home_phone, :user_id, 
                  :department_block_id, :secondary_email

  validates :first_name, :last_name, :presence => true

  has_many :user_availabilities, dependent: :destroy

  has_many :check_ins, dependent: :destroy

  has_many :user_schedules, dependent: :destroy
  has_many :department_blocks, :through => :user_schedules

  has_many :user_charities, dependent: :destroy
  has_many :charities, :through => :user_charities

  has_many :events

  has_one :department_manager, class_name: "User::DepartmentManager"
  has_one :department_assistant, class_name: "User::DepartmentAssistant"
  has_one :volunteer_manager, class_name: "User::VolunteerManager"

  before_save :default_values
  before_save :process_name
  after_update :reset_role_associations

  def default_values
    self.role ||= 'volunteer'
  end

  def reset_role_associations
    if self.role_changed?
      case self.role
      when 'volunteer'
        self.volunteer_manager ? self.volunteer_manager : ""
        self.department_assistant ? self.department_assistant.destroy : ""
        self.department_manager ? self.department_manager.destroy : ""
      when 'volunteer_manager'
        self.department_assistant ? self.department_assistant : "" 
        self.department_manager ? self.department_manager.destroy : ""
      when 'department_assistant'
        self.volunteer_manager ? self.volunteer_manager : ""
        self.department_manager ? self.department_manager.destroy : ""
      when 'department_manager'
        self.volunteer_manager ? self.volunteer_manager : ""
        self.department_assistant ? self.department_assistant.destroy : ""
      when 'event_manager'
        self.volunteer_manager ? self.volunteer_manager : ""
        self.department_assistant ? self.department_assistant.destroy : ""
        self.department_manager ? self.department_manager.destroy : ""
      end
    end
  end

  def full_name 
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  private

  def process_name
    self.first_name = first_name.strip
    self.last_name = last_name.strip
  end
end