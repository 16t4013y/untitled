class Recruitment < ApplicationRecord
  belongs_to :account
  has_many :comments, dependent: :destroy
  has_many :entry_chats, dependent: :destroy
  has_many :chat_comments, dependent: :destroy
  has_many :tagmaps, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :detail, presence: true
  validates :title, presence: true


  # タグ名の配列からそのタグをすべて含む発言を取得する
  def self._tagnamesearch(tagname)
    query = "SELECT recruitments.* FROM recruitments"
    if tagname.blank? then
      tmp = Recruitment.all
      tmp.order(updated_at: "DESC")
    else
      cnt = 0
      for i in 0..(tagname.length)
        if tagname[i] != "" && tagname[i] != nil then
          tagquery = "SELECT  tags.* FROM tags WHERE tags.tag_name = \"" + tagname[i].encode("cp932", :invalid => :replace, :undef => :replace) + "\" LIMIT 1"
          tagid = Tag.find_by_sql([tagquery])
          joinand = " INNER JOIN tagmaps AS tag"+(i+1).to_s+" ON tag"+(i+1).to_s+".recruitment_id = recruitments.id AND tag"+(i+1).to_s+".tag_id = "
          if tagid.present? then
            query = query + joinand + tagid[0][:id].to_s
          else
            query = query + joinand + "NULL"
          end
          cnt += 1
        end
      end
      if cnt != 0 then
        query = query + " ORDER BY recruitments.updated_at DESC"
        com = Recruitment.find_by_sql([query])
        if com.blank? then
          Recruitment.none
        else
          com
        end
      else
        tmp = Recruitment.all
        tmp.order(updated_at: "DESC")
      end
    end
  end


  # タグ名の配列からそのタグをすべて含む発言を取得する
  def self.tagnamesearch(tagname, limit, time, type)
    query = "SELECT recruitments.* FROM recruitments"
    if tagname.blank? then
      case type
      when 1 then #タイムライン
        com = Recruitment.where('updated_at < ?', time).order(updated_at: "DESC").limit(limit)
      when 2 then #発言
        com = Recruitment.where('updated_at < ?', time).where(re_id: '発言').order(updated_at: "DESC").limit(limit)
      when 3 then #募集
        com = Recruitment.where('updated_at < ?', time).where(re_id: '募集').where(resolved: '未解決').order(updated_at: "DESC").limit(limit)
      when 4 then #解決済み
        com = Recruitment.where('updated_at < ?', time).where(resolved: '解決').order(updated_at: "DESC").limit(limit)
      else
        com = nil
      end

    else
      cnt = 0
      for i in 0..(tagname.length)
        if tagname[i] != "" && tagname[i] != nil then
          tagquery = "SELECT  tags.* FROM tags WHERE tags.tag_name = \"" + tagname[i].encode("cp932", :invalid => :replace, :undef => :replace) + "\" LIMIT 1"
          tagid = Tag.find_by_sql([tagquery])
          joinand = " INNER JOIN tagmaps AS tag"+(i+1).to_s+" ON tag"+(i+1).to_s+".recruitment_id = recruitments.id AND tag"+(i+1).to_s+".tag_id = "
          if tagid.present? then
            query = query + joinand + tagid[0][:id].to_s
          else
            query = query + joinand + "NULL"
          end
          cnt += 1
        end
      end
      if cnt != 0 then
        case type
        when 1 then #タイムライン
          query = query + " WHERE recruitments.updated_at < \""+time.to_s+"\" ORDER BY recruitments.updated_at DESC LIMIT " + limit.to_s
        when 2 then #発言
          query = query + " WHERE recruitments.updated_at < \""+time.to_s+"\" AND recruitments.re_id = '発言' ORDER BY recruitments.updated_at DESC LIMIT " + limit.to_s
        when 3 then #募集
          query = query + " WHERE recruitments.updated_at < \""+time.to_s+"\" AND recruitments.re_id = '募集' AND recruitments.resolved = '未解決' ORDER BY recruitments.updated_at DESC LIMIT " + limit.to_s
        when 4 then #解決済み
          query = query + " WHERE recruitments.updated_at < \""+time.to_s+"\" AND recruitments.resolved = '解決' ORDER BY recruitments.updated_at DESC LIMIT " + limit.to_s
        else
          com = nil
        end
        com = Recruitment.find_by_sql([query])
        if com.blank? then
          com = Recruitment.none
        else
          com
        end
      else
        case type
        when 1 then #タイムライン
          com = Recruitment.where('updated_at < ?', time).order(updated_at: "DESC").limit(limit)
        when 2 then #発言
          com = Recruitment.where('updated_at < ?', time).where(re_id: '発言').order(updated_at: "DESC").limit(limit)
        when 3 then #募集
          com = Recruitment.where('updated_at < ?', time).where(re_id: '募集').where(resolved: '未解決').order(updated_at: "DESC").limit(limit)
        when 4 then #解決済み
          com = Recruitment.where('updated_at < ?', time).where(resolved: '解決').order(updated_at: "DESC").limit(limit)
        else
          com = nil
        end
      end
    end
    com
  end
end
