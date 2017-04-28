class HomeController < ApplicationController
  before_action :require_login
  $n = 2
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

    one_group_budget = Budget.new
    one_group_budget.group_id = one_group.id
    one_group_budget.group_budget = 0
    one_group_budget.save

    redirect_to "/home/index"
  end

  def group_page
    @group = Group.find(params[:group_id])
    @user = current_user
    @poll = Poll.where(group_id: @group.id)

  end

  def money_plus
    @old_budget = Budget.find(params[:group_id]).group_budget
    @money_plus = params[:money_plus]
    @new_budget = @money_plus.to_f + @old_budget.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)

    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_plus]
    one_transaction.description = params[:description_p]
    one_transaction.save

    redirect_to :back
  end

  def money_minus
    @old_budget = Budget.find(params[:group_id]).group_budget
    @money_minus = params[:money_minus]
    @new_budget =  @old_budget.to_f - @money_minus.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)

    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_minus]
    one_transaction.description = params[:description_m]
    one_transaction.pos_neg = false
    one_transaction.save

    redirect_to :back
  end
  def add_option
    $n = $n+1
    redirect_to :back
  end
  def new_poll
    one_poll = Poll.new
    one_poll.group_id = params[:group_id]
    one_poll.title = params[:poll_title]
    one_poll.save

    for i in 1..$n
      new_option = Option.new
      new_option.poll_id = one_poll.id
      new_option.content = params["option_content_#{i}"]
      new_option.save
    end

    redirect_to :back
  end

end
