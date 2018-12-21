############################################################################################
# GETリクエストに対して、大学情報を返す
# パラメータ
#   type = 0 : データベース中の全大学を返す
#   type = 1 , school = "" : データベース中の全学部を返す
# 　type = 1 , school = A  : A大学にある学部を返す
#   type = 2 , faculty = "" : データベース中の全学科を返す
# 　type = 1 , school = A , faculty = B : A大学, B学部にある学科を返す
############################################################################################
class UnivtagController < ApplicationController
  def list
    list = []
    if params.has_key?(:school) && params.has_key?(:faculty) && params.has_key?(:type) then
      if params[:type] == "0" then #大学取得
        list = Univinfo.where(stat: 0).pluck(:name)
      elsif params[:type] == "1" then  #学部取得
        if params[:school] != "" then
          univ = Univinfo.find_by(name: params[:school])
          if univ.present? then
            list = Univinfo.where(p_id: univ.id).pluck(:name)
          end
        else
          list = Univinfo.where(stat: 1).distinct.pluck(:name)#すべての学部
        end
      elsif params[:type] == "2" then #学科取得
        if params[:school] != "" && params[:faculty] != ""then
          univ = Univinfo.find_by(name: params[:school])
          if univ.present? then #大学が存在する
            faculty = Univinfo.find_by(name: params[:faculty], p_id: univ.id)
            if faculty.present? then
              list = Univinfo.where(p_id: faculty.id).pluck(:name)
            end
          end
        else #学部、学科が空
          if params[:school] == "" && params[:faculty] == "" then #大学も学部もすべて空
            list = Univinfo.where(stat: 2).distinct.pluck(:name)#すべての学科
          elsif params[:school] == "" && params[:faculty] != "" then #学部には情報が入っている
            faculty = Univinfo.where(name: params[:faculty]).pluck(:id) #学部名が同じ学部をすべて検索
            if faculty.present? then
              for i in 0..faculty.size-1 do # 検索した学部の持つすべての学科を取得
                list = Univinfo.where(p_id: faculty[i]).pluck(:name) | list
              end
            end
          else #大学には情報が入っている
            univ = Univinfo.find_by(name: params[:school]).id
            faculty = Univinfo.where(p_id: univ).pluck(:id) #大学のidを持つ学部をすべて検索
            if faculty.present? then
              for i in 0..faculty.size-1 do # 検索した学部の持つすべての学科を取得
                list = Univinfo.where(p_id: faculty[i]).pluck(:name) | list
              end
            end
          end
        end
      end
    end
    render json: list
  end
end
