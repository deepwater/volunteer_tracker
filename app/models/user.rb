class User < ActiveRecord::Base
  rolify

  TSHIRT_SIZES = %w[S M L XL XXL XXXL]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, 
                  :last_name, :tshirt_size, :role, :cell_phone, :home_phone, :master_id, 
                  :department_block_id, :secondary_email, :username, :organisation_id

  validates :first_name, :last_name, presence: true
  validates :organisation_id, presence: true, unless: :super_admin?
  validates :username, presence: true
  validates :username, uniqueness: { scope: :organisation_id }
  validates :email, uniqueness: true, unless: :subaccount?
  validates :email, presence: true, unless: :subaccount?
  validates :password, presence: true, if: :password_required_on_update?
  validates_confirmation_of :password, if: :password_required?

  has_many :user_availabilities, dependent: :destroy

  has_many :check_ins, dependent: :destroy

  has_many :user_schedules, dependent: :destroy
  has_many :department_blocks, :through => :user_schedules

  has_many :user_charities, dependent: :destroy
  has_many :charities, :through => :user_charities

  has_many :events

  belongs_to :master, class_name: 'User'
  has_many :subaccounts, class_name: 'User', foreign_key: :master_id, dependent: :destroy

  has_one :department_manager
  has_one :department_assistant
  has_one :volunteer_manager

  belongs_to :organisation

  before_save :default_values
  before_save :process_name
  after_update :reset_role_associations

  def default_values
    self.role ||= 'volunteer'
  end

  def reset_role_associations
    if self.role_changed?
      self.add_role self.role # temporary fix for current ACL system
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

  def subaccount?
    master_id.present?
  end

  def super_admin?
    self.has_role?(:super_admin)
  end

  def password_required?
    !subaccount? && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end

  def password_required_on_update?
    password_required? && persisted?
  end

  def process_name
    self.first_name = first_name.strip
    self.last_name = last_name.strip
  end

end