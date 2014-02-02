class Organisation < ActiveRecord::Base
  attr_accessible :name, :subdomain

  has_many :events, dependent: :destroy

  validates_format_of :subdomain, with: /^[a-z0-9_]+$/
  validates_length_of :subdomain, maximum: 32
  validates_exclusion_of :subdomain, in: ['www', 'mail', 'ftp', 'api', 'admin']
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
end
