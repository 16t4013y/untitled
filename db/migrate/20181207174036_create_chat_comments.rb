class CreateChatComments < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_comments do |t|
      t.integer :chat_id
      t.string :acc_id
      t.date :time
      t.string :comment
      t.integer :file_id
      t.bigint :account_id, null: false , index: true
      t.bigint :recruitment_id, null: false , index: true

      t.timestamps
    end
  end
end
