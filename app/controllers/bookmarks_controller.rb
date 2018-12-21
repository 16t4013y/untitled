class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = Bookmark.all
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.account_id = current_account.id
    @bookmark.save
    # respond_to do |format|
    #  if @bookmark.save
    #    format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
    #    format.json { render :show, status: :created, location: @bookmark }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @bookmark.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @new_bookmark = Bookmark.new
    @new_bookmark.account_id = @bookmark.account_id
    @new_bookmark.recruitment_id = @bookmark.recruitment_id
    @bookmark.destroy
    #respond_to do |format|
    #  format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:recruitment_id)
    end
end
