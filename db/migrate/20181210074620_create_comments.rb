class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.bigint :recruitment_id, null: false, index: true # 所有関係記述のためのID
      t.bigint :account_id, null: false, index: true # 所有関係記述のためのID
      t.string  :message  , null:false, limit: 1000
      t.integer :file_id

      t.timestamps
    end
  end
end