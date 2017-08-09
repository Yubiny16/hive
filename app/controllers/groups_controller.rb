class GroupsController < ApplicationController
  def index
    @groups = Group.order(:name).where("name like ?", "%#{params[:term]}%")
    #render json: @groups.map(&:name)
    @user_groups = GroupUser.where(user_id: current_user.id)
    @searched_groups = Group.where("name LIKE ?", "%#{@search}%")
  end
end
