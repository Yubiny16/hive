class HomeController < ApplicationController
  before_action :require_login
  def index
    @user = current_user
    @search = flash[:search]

    if @search == nil
      @search = "dlksfjalkdfjwgvd"
    else
      @search = flash[:search]
    end
  end

  def search
    flash[:search] = params[:search_group]
    redirect_to "/home/index"
  end

  def profile
    @user = current_user
  end
  def my_friends
    @user = current_user
  end

  def create_group_view

  end

  def join_group
    user = current_user
    one_group_user = GroupUser.new
    one_group_user.group_id = params[:group_id]
    one_group_user.email = user.email

    find_grp_nm = Group.find_by(id: params[:group_id])

    one_group_user.name = find_grp_nm.name
    one_group_user.save
    redirect_to controller: 'home', action: 'group_page', id: :group_id
  end

  def create_group

    one_group = Group.new
    one_group.name = params[:group_name]
    one_group.school = params[:group_school]
    one_group.save

    user = current_user

    one_group_user = GroupUser.new
    one_group_user.group_id = one_group.id
    one_group_user.email = user.email
    one_group_user.name = one_group.name
    one_group_user.save
    redirect_to "/home/index"
  end

  def group_page
    @group = Group.find(params[:group_id])
    @user = current_user
  end
  


end
