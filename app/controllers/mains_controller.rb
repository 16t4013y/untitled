class MainsController < ApplicationController

  def index
    if params.has_key?(:view_num) then
      @view_num = params[:view_num]
    else
      @view_num = '1'
    end
    logger.debug(@view_num)
    @view_com_num = '5'
    @bookmark = Bookmark.new

    @recruitment = Recruitment.new

    if account_signed_in? then #ログインしている
      @taghistoryid = Taghistoryid.new #履歴用に変数準備
      if params.has_key?(:school) then #パラメータを受け取っている
        @inputtag = Inputtag.new(inputtag_params) #入力されているタグを取得
        @inputtag.freetagnum = @inputtag.count_freetag
        @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2, DateTime.tomorrow, @view_num.to_i) #入力されているタグで検索
      else #パラメータを受け取っていない
        @inputtag = Inputtag.new
        if current_account.id != 1 then
          @inputtag.setuniv(school: current_account.university, faculty: current_account.faculty, department: current_account.department) #タグに大学情報セット
        end
        @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2, DateTime.tomorrow, 1)
      end
    else #ログインしていない
      if params.has_key?(:school) then #パラメータを受け取っている
        @inputtag = Inputtag.new(inputtag_params) #入力されているタグを取得
        @inputtag.freetagnum = @inputtag.count_freetag
        @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2, DateTime.tomorrow, @view_num.to_i) #入力されているタグで検索
      else
        @inputtag = Inputtag.new
        @recruitments = Recruitment.tagnamesearch([],2, DateTime.tomorrow, 1)
      end
    end

    render template: 'mains/add_index'
  end

  def add_index
    #@view_num = '1'
    #@view_com_num = '5'
    #@bookmark = Bookmark.new

    @recruitment = Recruitment.new
    @inputtag = Inputtag.new
    @view_num =params[:view_num]
    if params[:school].present? then #パラメータを受け取っている
      @inputtag = Inputtag.new(inputtag_params)
      @inputtag.freetagnum = @inputtag.count_freetag
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2, params[:oldest].to_time, @view_num.to_i) #入力されているタグで検索
    else #パラメータを受け取っていない
      @inputtag = Inputtag.new
      if account_signed_in? && current_account.id != 1 then
        @inputtag.setuniv(school: current_account.university, faculty: current_account.faculty, department: current_account.department) #タグに大学情報セット
      end
      @inputtag.freetagnum = @inputtag.count_freetag
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2, DateTime.tomorrow, @view_num.to_i)
    end
    for tag in @inputtag.tag_to_arry.each do
      logger.debug(tag)
    end
    tmp = "view_num="+params[:view_num]
    logger.debug(tmp)
    if account_signed_in? then #ログインしている
      taghistoryid = Taghistoryid.new #履歴用に変数準備
    end

  end

  def button_view
    @inputtag = Inputtag.new(inputtag_params)#入力されているタグを取得

    @inputtag.freetagnum = @inputtag.count_freetag
    if account_signed_in? then #ログインしている
      @taghistoryid = Taghistoryid.new
    end
    @view_num = params[:id]
    if @view_num == '1'
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2,DateTime.tomorrow,1) #タイムライン
    elsif @view_num == '2'
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2,DateTime.tomorrow,2) #発言
    elsif @view_num == '3'
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2,DateTime.tomorrow,3) #募集
    elsif @view_num == '4'
      @recruitments = Recruitment.tagnamesearch(@inputtag.tag_to_arry,2,DateTime.tomorrow,4) #解決済み募集
    end
  end

  def button_form
    @view_num =params[:view_num]
    @bookmark = Bookmark.new

    @recruitment = Recruitment.new
    @inputtag = Inputtag.new(inputtag_params)#入力されているタグを取得

    @inputtag.freetagnum = @inputtag.count_freetag

    if account_signed_in? then #ログインしている
      @taghistoryid = Taghistoryid.new
    end

      @view_com_num = params[:id]

    if account_signed_in? then
      @inputtag.setuniv school: current_account.university, faculty: current_account.faculty, department: current_account.department
    end
  end



  #タグ検索フォームの情報を取得する
  def inputtag_params
    params.permit(:school, :faculty, :department, :tag1, :tag2, :tag3, :tag4, :tag5, :tag6, :tag7, :tag8, :tag9, :tag10)
  end

end
