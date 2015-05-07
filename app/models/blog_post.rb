class BlogPost < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user

  validates :text, :user_id, presence: true
end
