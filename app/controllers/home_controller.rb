class HomeController < ApplicationController
  before_action :require_login
  $n = 2
  def index
    @user = current_user
    # this is the search words came from search method
    @search = flash[:search]

    # if user enters a blank string @search becomes dlksfjalkdfjwgvd to stop any group from being searched
    if @search == nil
      @search = "dlksfjalkdfjwgvd"
    else
      @search = flash[:search]
    end
  end

  def search
    # use flash to pass search words to index method
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
    one_group_user.user_id = user.id

    find_grp_nm = Group.find_by(id: params[:group_id])

    one_group_user.group_id = find_grp_nm.id
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
    one_group_user.user_id = user.id
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
    #Find the value of previous budget balance
    @old_budget = Budget.find(params[:group_id]).group_budget
    #How much to add
    @money_plus = params[:money_plus]
    # Change to integer
    @new_budget = @money_plus.to_f + @old_budget.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)
    # Add new transaction to DB
    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_plus]
    one_transaction.description = params[:description_p]
    one_transaction.save

    redirect_to :back
  end

  def money_minus
    #Find the value of previous budget balance
    @old_budget = Budget.find(params[:group_id]).group_budget
    #How much to subtract
    @money_minus = params[:money_minus]
    # Change to integer
    @new_budget =  @old_budget.to_f - @money_minus.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)
    # Add new transaction to DB
    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_minus]
    one_transaction.description = params[:description_m]
    one_transaction.pos_neg = false
    one_transaction.save

    redirect_to :back
  end
  def add_option
    # add option to global variable $n
    $n = $n+1
  end
  def new_poll
    # Create new poll DB
    one_poll = Poll.new
    one_poll.group_id = params[:group_id]
    one_poll.title = params[:poll_title]
    one_poll.save

    # Create new Options
    for i in 1..$n
      new_option = Option.new
      # To see which poll these options belong to
      new_option.poll_id = one_poll.id
      new_option.content = params["option_content_#{i}"]
      new_option.save
    end
    # return $n to 2 cuz that's the default number of options
    $n =2
    redirect_to :back
  end
  def option_select
    # Is it the user's first time voting? if yes...
    if Polluser.where(user_id: current_user.id).where(poll_id: params[:poll_id]).exists?
      Polluser.where(user_id: current_user.id).where(poll_id: params[:poll_id]).find do |polluser|
        # Increase the number of votes for this option by 1
        @vote_number = Option.find(params[:optradio]).vote_number
        Option.update(params[:optradio], :vote_number => @vote_number + 1)
        # Update Polluser now that user has voted for the first time or changed vote
        Polluser.update(polluser.id, :option_id => params[:optradio])
        Polluser.update(polluser.id, :voted => true)
      end
    else
      # Increase the number of votes for this option by 1
      @vote_number = Option.find(params[:optradio]).vote_number
      Option.update(params[:optradio], :vote_number => @vote_number + 1)
      # create new polluser to store user's vote.
      one_polluser = Polluser.new
      one_polluser.user_id = current_user.id
      one_polluser.poll_id = params[:poll_id]
      one_polluser.option_id = params[:optradio]
      one_polluser.voted = true
      one_polluser.save
    end
    redirect_to :back
  end
  def option_cancel
    # find the user's vote
    Polluser.where(poll_id: params[:poll_id]).where(user_id: current_user.id).where(voted: true).find do |polluser|
    @option_id = polluser.option_id
    # decrease the number of votes for this option by 1
    @vote_number = Option.find(@option_id).vote_number
    Option.update(@option_id, :vote_number => @vote_number - 1)
    # User's vote has been revoked
    Polluser.update(polluser.id, :voted => false)
    end
    redirect_to :back
  end
  def delete_poll
    @one_poll = Poll.destroy_all(id: params[:poll_id])
    @pollusers = Polluser.destroy_all(poll_id: params[:poll_id])
    @options = Option.destroy_all(poll_id: params[:poll_id])

    redirect_to :back
  end

end