class CreateTaghistories < ActiveRecord::Migration[5.2]
  def change
    #drop_table :taghistories
    create_table :taghistories do |t|
      t.string :acc_id , null:false
      t.string  :univtag, limit: 30
      t.string  :faculty, limit: 30
      t.string  :department, limit: 30
      t.string  :tag1, limit: 30
      t.string  :tag2, limit: 30
      t.string  :tag3, limit: 30
      t.string  :tag4, limit: 30
      t.string  :tag5, limit: 30
      t.string  :tag6, limit: 30
      t.string  :tag7, limit: 30
      t.string  :tag8, limit: 30
      t.string  :tag9, limit: 30
      t.string  :tag10, limit: 30
      t.string  :display, limit: 391
      t.timestamps
    end
  end
end
