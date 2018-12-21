class Inputtag
  include ActiveModel::Model
  attr_accessor :school, :faculty, :department, :tag1, :tag2, :tag3, :tag4, :tag5, :tag6, :tag7, :tag8, :tag9, :tag10, :freetagnum

  #大学、学部、学科タグを登録する
  def setuniv(school:, faculty:, department:)
    self.school = school
    self.faculty = faculty
    self.department = department
  end

  #自由タグを数える。空白と重複は数えない
  def count_freetag
    tmp = []

    for i in 0..9
      tmp[i] = ""
    end

    if !check(self.school) then
      self.school = ""
    end
    if !check(self.faculty) then
      self.faculty = ""
    end
    if !check(self.department) then
      self.department = ""
    end
    i=0
    if check(self.tag1) then
      tmp[i] = self.tag1
      i +=1
    end
    if check(self.tag2) then
      tmp[i] = self.tag2
      i +=1
    end
    if check(self.tag3) then
      tmp[i] = self.tag3
      i +=1
    end
    if check(self.tag4) then
      tmp[i] = self.tag4
      i +=1
    end
    if check(self.tag5) then
      tmp[i] = self.tag5
      i +=1
    end
    if check(self.tag6) then
      tmp[i] = self.tag6
      i +=1
    end
    if check(self.tag7) then
      tmp[i] = self.tag7
      i +=1
    end
    if check(self.tag8) then
      tmp[i] = self.tag8
      i +=1
    end
    if check(self.tag9) then
      tmp[i] = self.tag9
      i +=1
    end
    if check(self.tag10) then
      tmp[i] = self.tag10
      i +=1
    end
    tmp.uniq!
    tmp = tmp.sort
    tmp = tmp.reject(&:blank?)
    self.tag1 = tmp[0]
    self.tag2 = tmp[1]
    self.tag3 = tmp[2]
    self.tag4 = tmp[3]
    self.tag5 = tmp[4]
    self.tag6 = tmp[5]
    self.tag7 = tmp[6]
    self.tag8 = tmp[7]
    self.tag9 = tmp[8]
    self.tag10= tmp[9]

    i
  end

  #タグを配列にして返す
  def tag_to_arry
    [self.school,self.faculty,self.department,self.tag1,self.tag2,self.tag3,self.tag4,self.tag5,self.tag6,self.tag7,self.tag8,self.tag9,self.tag10]
  end

  private
  #strが空文字やnilでなく、「"」「'」を含んでいないことをチェックする
  def check(str)
    if str == nil || str==""  || str.include?("\"") || str.include?("'") || str.include?("`") || str.length > 30 then
      false
    else
      true
    end
  end
end
