class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
