class CreateTags < ActiveRecord::Migration[5.2]
  def change
    #drop_table :tags
    create_table :tags do |t|
      t.boolean :tag_type, null:false
      t.string :tag_name, limit: 30, null:false
      t.integer :com_count, null:false

      t.timestamps
    end

  end
end
