class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.bigint :account_id, null:false , index: true
      t.bigint :recruitment_id, null:false ,index: true

      t.timestamps
    end
  end
end
