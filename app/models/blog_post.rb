class BlogPost < ActiveRecord::Base
  belongs_to :user

  validates :text, :user_id, presence: true
end
