class CreateTagmaps < ActiveRecord::Migration[5.2]
  def change
    #drop_table :tagmaps
    create_table :tagmaps do |t|
      t.bigint :recruitment_id, null: false , index: true
      t.bigint :tag_id, null: false , index: true
      t.timestamps
    end
  end
end
