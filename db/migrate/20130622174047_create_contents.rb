class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :user
      t.string 'title'
      t.string 'description'
      t.string 'content_type'
      t.string 'file_type'
      t.string 'link'
      t.boolean 'privacy'
      t.boolean 'name'
      t.integer 'upvotes'
      t.integer 'views'
      t.timestamps
    end
     add_index("contents", "user_id")
  end
end
