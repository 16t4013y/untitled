class Picture < ActiveRecord::Base

  # photoをattachファイルとする。stylesで画像サイズを定義できる
  has_attached_file :photo,# styles: { medium: "300x300>"},
  :url  => "/assets/arts/:id/:style/:basename.:extension", # 画像保存先のURL先
      :path => "#{Rails.root}/public/assets/arts/:id/:style/:basename.:extension" # サーバ上の画像保存先パス

  # ファイルの拡張子を指定（これがないとエラーが発生する）
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif","application/pdf","application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document"] },
                       presence: true,  # ファイルの存在チェック
                       less_than: 5.megabytes# ファイルサイズのチェック
end
