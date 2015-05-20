class Organisation < ActiveRecord::Base
  resourcify

  has_many :events, dependent: :destroy
  has_many :users

  validates_format_of :subdomain, with: /\A[a-z0-9_]+\z/
  validates_length_of :subdomain, maximum: 32
  validates_exclusion_of :subdomain, in: %w(www ftp mail pop smtp admin ssl sftp api staging)
  
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
end
