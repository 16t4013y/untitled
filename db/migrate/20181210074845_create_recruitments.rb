class CreateRecruitments < ActiveRecord::Migration[5.2]
  def change
    create_table :recruitments do |t|
      t.string :acc_id, :limit=>20   #アカウントID
      t.string :re_id                #発言/募集
      t.string :resolved             #解決/未解決
      t.string :title, :limit => 100 #募集タイトル
      t.string :detail, :limit=>1000 #発言本文or募集詳細文
      t.string :answer, :limit=>1000 #結果本文
      t.string :file_id              #ファイルID
      t.string :chat                 #チャットの有無

      t.bigint :account_id, null: false , index: true

      t.timestamps
    end
  end
end
