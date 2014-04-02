class User < ActiveRecord::Base
require 'csv'
  rolify

  TSHIRT_SIZES = %w[S M L XL XXL XXXL]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, 
                  :last_name, :tshirt_size, :role, :cell_phone, :home_phone, :master_id, 
                  :department_block_id, :secondary_email, :username, :organisation_id, :adult

  validates :first_name, :last_name, presence: true
  validates :organisation_id, presence: true, unless: :super_admin?
  validates :username, presence: true
  validates :username, uniqueness: { scope: :organisation_id }
  validates :email, uniqueness: true, unless: :subaccount?
  validates :email, presence: true, unless: :subaccount?
  validates :password, presence: true, if: :password_required_on_update?
  validates_confirmation_of :password, if: :password_required?
  validates_uniqueness_of :email, allow_blank: true, case_sensitive: false
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true

  has_many :user_availabilities, dependent: :destroy

  has_many :check_ins, dependent: :destroy

  has_many :user_schedules, dependent: :destroy
  has_many :department_blocks, through: :user_schedules

  has_many :user_charities, dependent: :destroy
  has_many :charities, through: :user_charities

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

  def add_charity_by_name(charity_name)
    # TODO: trim charities name
    charity = Charity.where("name LIKE :prefix", prefix: "#{charity_name}%").first
    return unless charity
    self.charities << charity
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

  def self.import(file, accessor)
    success_count, errors = 0, {}
    CSV.foreach(file.path, headers: false) do |row|
      user = User.new({
        first_name: row[0],
        last_name: row[1],
        username: row[2],
        cell_phone: row[3],
        home_phone: row[4],
        email: row[5],
        tshirt_size: row[6],
        master_id: accessor.id,
        organisation_id: Organisation.first.try(:id)
      })
      user.skip_confirmation!
      if user.save
        success_count += 1
        user.add_charity_by_name(row[7])
      else
        errors[row[2]] = user.errors.full_messages
      end
    end
    { true  => { status: :success, subaccount_count: success_count },
      false => { status: :error, errors: errors }
    }[errors.blank?]
  end

end