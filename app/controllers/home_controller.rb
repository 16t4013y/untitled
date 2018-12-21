class HomeController < ApplicationController
  def index
  end

  # アカウント情報画面
  def show

    @home_button = '1'
    @view_num = '1'
    @account = Account.find_by(acc_id: params[:acc_id])
    if @account.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: '存在しないアカウントです' }
        format.json { head :no_content }
      end
    else
      @recruitments = @account.recruitments.order(updated_at: "DESC")
      @entry_chats = @account.entry_chats
    end
  end


  # アカウント削除画面
  def delete
    @account = Account.find_by(acc_id: params[:acc_id])
    if @account.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: '存在しないアカウントです' }
        format.json { head :no_content }
      end
    elsif @account.id != current_account.id
      respond_to do |format|
        format.html { redirect_to root_path, notice: '削除権限がありません' }
        format.json { head :no_content }
      end
    end
  end

  def button
    @home_button = params[:id]
    @view_num = '1'
    @account = Account.find_by(acc_id: params[:acc_id])
    if @account.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: '存在しないアカウントです' }
        format.json { head :no_content }
      end
    else
      if @home_button == '1'
      @recruitments = @account.recruitments.order(updated_at: "DESC")
      elsif @home_button == '2'
        @recruitments = current_account.bookmark_recruitments
      elsif @home_button == '3'
        @entry_chats = @account.entry_chats
      end

      render template: 'home/show'
    end
  end

  def button_view
    @account = Account.find_by(acc_id: params[:acc_id])
    @view_num = params[:id]
    if @view_num == '1'
      @recruitments = @account.recruitments.order(updated_at: "DESC")                         #タイムライン
    elsif @view_num == '2'
      @recruitments = @account.recruitments.where(re_id: '発言').order(updated_at: "DESC")    #発言
    elsif @view_num == '3'
      @recruitments = @account.recruitments.where(resolved: '未解決').order(updated_at: "DESC") #募集
    elsif @view_num == '4'
      @recruitments = @account.recruitments.where(resolved: '解決').order(updated_at: "DESC") #解決済み募集
    end
  end

end