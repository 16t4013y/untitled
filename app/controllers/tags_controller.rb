############################################################################################
# タグ検索に関して処理を行う
# 検索フォームに入力されたタグからデータを検索し、結果を表示する
# 検索フォームに入力されたタグをタグ履歴に登録する
# ##########################################################################################
class TagsController < ApplicationController

  #タグ検索フォーム、履歴検索フォーム用
  def update
    if params[:type] == "input" then
      @inputtag = Inputtag.new(inputtag_params)
    else
      if params[:taghistoryid][:id] != "" then
        @inputtag = set_taghistory(params[:taghistoryid][:id])
      else
        history = Taghistory.find_by(display: nil)
        if history.present? then
          history.touch
          history.save
        else
          history = Taghistory.new(acc_id: current_account.acc_id)
          history.save
        end
        @inputtag = Inputtag.new
      end
    end
    @view_num = '1'
    @view_com_num = '5'
    @inputtag.freetagnum = @inputtag.count_freetag #タグの数をかうんと

    @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry, 2, DateTime.tomorrow, params[:view_num].to_i) #入力タグで検索
    @recruitment = Recruitment.new
    @taghistoryid = Taghistoryid.new
    if account_signed_in? && params[:type] == "input" then
      add_taghistory(inputtag_params)
    end
    render template: 'mains/add_index'
  end

  private
  #タグ検索フォームの情報を取得する
  def inputtag_params
    if params.has_key?(:inputtag) then
      params.require(:inputtag).permit(:school, :faculty, :department, :tag1, :tag2, :tag3, :tag4, :tag5, :tag6, :tag7, :tag8, :tag9, :tag10)
    else
      params.permit(:school, :faculty, :department, :tag1, :tag2, :tag3, :tag4, :tag5, :tag6, :tag7, :tag8, :tag9, :tag10)
    end
  end


  #指定した履歴IDの履歴を取得
  def set_taghistory(id)
    history = Taghistory.find(id)
    history.touch
    history.save
    if history.present? then
      Inputtag.new(school: history[:univtag], faculty: history[:faculty], department: history[:department], tag1: history[:tag1], tag2: history[:tag2], tag3: history[:tag3], tag4: history[:tag4], tag5: history[:tag5], tag6: history[:tag6], tag7: history[:tag7], tag8: history[:tag8], tag9: history[:tag9], tag10: history[:tag10])
    else
      Inputtag.new
    end
  end

  # 検索フォームのタグを履歴に保存
  # 重複する場合は時刻のみ更新
  def add_taghistory(tag)
    freetag = []
    school = []
    display = ""
    if tag[:school] != "" then
      school[0] = tag[:school]
      display = display + tag[:school] + "  "
    else
      school[0] = nil
    end
    if tag[:faculty] != "" then
      school[1] = tag[:faculty]
      display = display + tag[:faculty] + "  "
    else
      school[1] = nil
    end
    if tag[:department] != "" then
      school[2] = tag[:department]
      display = display + tag[:department] + "  "
    else
      school[2] = nil
    end

    if tag[:tag1] != "" then
      freetag[0] = tag[:tag1]
      display = display + tag[:tag1] + "  "
    else
      freetag[0] = nil
    end
    if tag[:tag2] != "" then
      freetag[1] = tag[:tag2]
      display = display + tag[:tag2] + "  "
    else
      freetag[1] = nil
    end
    if tag[:tag3] != "" then
      freetag[2] = tag[:tag3]
      display = display + tag[:tag3] + "  "
    else
      freetag[2] = nil
    end
    if tag[:tag4] != "" then
      freetag[3] = tag[:tag4]
      display = display + tag[:tag4] + "  "
    else
      freetag[3] = nil
    end
    if tag[:tag5] != "" then
      freetag[4] = tag[:tag5]
      display = display + tag[:tag5] + "  "
    else
      freetag[4] = nil
    end
    if tag[:tag6] != "" then
      freetag[5] = tag[:tag6]
      display = display + tag[:tag6] + "  "
    else
      freetag[5] = nil
    end
    if tag[:tag7] != "" then
      freetag[6] = tag[:tag7]
      display = display + tag[:tag7] + "  "
      else
      freetag[6] = nil
    end
    if tag[:tag8] != "" then
      freetag[7] = tag[:tag8]
      display = display + tag[:tag8] + "  "
    else
      freetag[7] = nil
    end
    if tag[:tag9] != "" then
      freetag[8] = tag[:tag9]
      display = display + tag[:tag9] + "  "
    else
      freetag[8] = nil
    end
    if tag[:tag10] != "" then
      freetag[9] = tag[:tag10]
      display = display + tag[:tag10] + "  "
    else
      freetag[9] = nil
    end
    freetag.uniq!
    freetag = freetag.compact.sort
    if display == "" then
      display = nil
    end
    tmp = Taghistory.find_by(acc_id: current_account.acc_id,univtag:school[0], faculty:school[1], department:school[2], tag1:freetag[0], tag2:freetag[1], tag3:freetag[2], tag4:freetag[3], tag5:freetag[4], tag6:freetag[5], tag7:freetag[6], tag8:freetag[7], tag9:freetag[8], tag10:freetag[9])
    if tmp.blank? then
      taghistory = Taghistory.new({acc_id: current_account.acc_id,univtag:school[0], faculty:school[1], department:school[2], tag1:freetag[0], tag2:freetag[1], tag3:freetag[2], tag4:freetag[3], tag5:freetag[4], tag6:freetag[5], tag7:freetag[6], tag8:freetag[7], tag9:freetag[8], tag10:freetag[9], display:display})
      taghistory.save
    else
      tmp.touch
      tmp.save
    end
  end
end
