class GroupsController < ApplicationController
  def index
    @groups = Group.order(:name).where("name like ?", "%#{params[:term]}")
    render json: @groups.map(&:name)
  end
end
