class Tag < ApplicationRecord
  self.primary_key = 'tag_id'

  #タグ名からタグIDを取得、一致するモノがなければnil
  def self.getid(tagname)
    if tagname.present? then
      tagid = Tag.where(tag_name: tagname.encode("cp932", :invalid => :replace, :undef => :replace))
      if tagid.present? then
        tagid[0][:tag_id]
      else
        nil
      end
    else
      nil
    end
  end

  #タグIDからタグ名を取得、一致するモノがなければnil
  def self.getname(tagid)
    tagname = Tag.where(tag_id: tagid)
    if tagname.present? then
      tagname[0][:tag_name]
    else
      nil
    end
  end

  #タグ名に該当するタグのコメント数を1増やす
  #該当するタグがない場合、新たにタグを作成する
  def self.increment(tagname)
    tagid = Tag.getid(tagname)
    if tagid.nil? then
      tagid = Tag.maximum(:tag_id) + 1
      tag = Tag.new(tag_id: tagid, tag_type: false ,tag_name: tag_name,com_count: '1')
    else
      tag = Tag.find(tagid)
      tag.com_count += 1
    end
    tag.save
    tagid
  end

  #タグ名に該当するタグのコメント数を1減らす
  #コメント数が０の自由タグは削除する
  def self.decrement(tagid)
    if tagid.present? then
      tag = Tag.find(tagid)
      tag.com_count -= 1
      if !tag.tag_type? then
        if tag.com_count == 0 then
          Tag.find(tagid).destroy
        else
          tag.save
        end
      else
        tag.save
      end
    end
  end
end
