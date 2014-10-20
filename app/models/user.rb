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
                  :department_block_id, :secondary_email, :username, :organisation_id, :adult, :login,
                  :charity_ids

  attr_accessor :login

  validates :first_name, :last_name, presence: true
  validates :organisation_id, presence: true, unless: :super_admin?
  validates :username, presence: true
  validates :username, uniqueness: { scope: :organisation_id, case_sensitive: false }
  validates :email, presence: true, unless: :subaccount?
  validates :password, presence: true, if: :password_required_on_update?
  validates_confirmation_of :password, if: :password_required?
  validate :email_uniquality_for_main_acccount

  has_many :user_availabilities, dependent: :destroy

  has_many :check_ins, dependent: :destroy

  has_many :user_schedules, dependent: :destroy
  has_many :department_blocks, through: :user_schedules

  has_many :user_charities, dependent: :destroy
  has_many :charities, through: :user_charities
  accepts_nested_attributes_for :charities

  has_many :events

  belongs_to :master, class_name: 'User'
  has_many :subaccounts, class_name: 'User', foreign_key: :master_id, dependent: :destroy

  has_one :department_manager, dependent: :destroy
  has_one :department_assistant, dependent: :destroy
  has_one :volunteer_manager, dependent: :destroy

  belongs_to :organisation

  before_save :default_values
  before_save :process_name
  after_update :reset_role_associations

  def default_values
    self.role ||= 'volunteer'
    self.add_role self.role unless self.has_role? self.role
  end

  def reset_role_associations
    if self.role_changed?
      self.roles = []
      self.add_role self.role
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
      when 'event_admin'
        self.volunteer_manager ? self.volunteer_manager : ""
        self.department_assistant ? self.department_assistant.destroy : ""
        self.department_manager ? self.department_manager.destroy : ""
      end
    end
  end

  def full_name
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where("master_id IS NULL").where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).where("master_id IS NULL").first
    end
  end

  def master?
    subaccounts.present?
  end

  def subaccount?
    master_id.present?
  end

  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation

    if new_password == new_password_confirmation
      clear_reset_password_token
      after_password_reset
    end

    self.save(validate: false)
  end

  private

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

  def email_uniquality_for_main_acccount
    if !subaccount?
      if !persisted? && self.class.where(email: self.email, master_id: nil).exists?
        self.errors.add(:email, "has already been taken")
      elsif persisted? && self.class.where("id != #{self.id}").where(email: self.email, master_id: nil).exists?
        self.errors.add(:email, "has already been taken")
      end
    end
  end

end
