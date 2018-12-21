class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  # GET /comments
  # GET /comments.json
  def index
    @recruitment = Recruitment.find_by(id: params[:recruitment_id])
    if @recruitment.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: '返信先がありません' }
        format.json { head :no_content }
      end
      return
    end
    @comment = Comment.new(recruitment_id: params[:recruitment_id])
    @comments = @recruitment.comments.limit(20) #20件を取得
  end

  # 表示する返信の追加
  def add_index

    #ajax通信以外は弾く
    return redirect_to '/404.html' unless request.xhr?

    @recruitment = Recruitment.find_by(id: params[:recruitment_id])
    if @recruitment.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: '返信先がありません' }
        format.json { head :no_content }
      end
      return
    end
    @comments = @recruitment.comments.where('updated_at > ?', Time.zone.parse(params[:offset_time])).limit(20)
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    if !account_signed_in? #発言権限はあるか
      respond_to do |format|
        format.html { redirect_to root_path, notice: '発言するには、ログインしてください' }
        format.json { head :no_content }
      end
    elsif @comment.recruitment.nil? # 返信先は存在するか
      respond_to do |format|
        format.html { redirect_to root_path, notice: '返信先がありません' }
        format.json { head :no_content }
      end
    else
      @comment.account_id = current_account.id # アカウントの主キーのID
      if @comment.save
        @comment.recruitment.touch
        @comment.recruitment.save
        respond_to do |format|

          format.html { redirect_to comments_index_path(@comment.recruitment_id), notice: '発言を投稿しました' }
          format.json { render :index, status: :created, location: @comment }
        end
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.nil?  #削除すべきコメントは存在したか
      respond_to do |format|
        format.html { redirect_to root_path, notice: '削除すべき発言はありませんでした' }
        format.json { head :no_content }
      end
    elsif !(account_signed_in? and (@comment.account.id == current_account.id or current_account.acc_id == 'administrator')) #削除権限があるか
      recruitment_id = @comment.recruitment_id
      respond_to do |format|
        format.html { redirect_to comments_index_path(recruitment_id), notice: '削除権限がありません' }
        format.json { head :no_content }
      end
    else
      recruitment_id = @comment.recruitment_id
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to comments_index_path(recruitment_id), notice: '発言を削除しました' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:recruitment_id, :message, :file_id)
    end
end
