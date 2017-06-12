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

  def uploadprofpic
    uploader = UserprofileUploader.new
    uploader.store!(params[:pic])

    @user = current_user
    @user.image_url = uploader.url
    @user.save

    redirect_to "/home/profile"
  end

  def my_friends
    @user = current_user
  end

  def create_group_view

  end

  def join_group
     user = current_user
     this_group = Group.find_by(id: params[:group_id])

     if params[:group_pw] == this_group.password
       one_group_user = GroupUser.new
       one_group_user.group_id = params[:group_id]
       one_group_user.user_id = user.id
       one_group_user.save

       redirect_to controller: 'home', action: 'group_page', id: :group_id
     else
       redirect_to :back
       #jquery로 패스워드 틀렸다 말하기
     end

   end

  def create_group

    one_group = Group.new
    one_group.name = params[:group_name]
    one_group.school = params[:group_school]
    one_group.password = params[:group_pw]
    one_group.save

    user = current_user

    one_group_user = GroupUser.new
    one_group_user.group_id = one_group.id
    one_group_user.user_id = user.id
    one_group_user.admin = true
    one_group_user.save

    one_group_budget = Budget.new
    one_group_budget.group_id = one_group.id
    one_group_budget.group_budget = 0
    one_group_budget.save

    redirect_to "/home/index"
  end

  def group_page
    @group = Group.find(params[:group_id])
    #global variable $group_id to be used in events controller
    $group_id = @group.id
    @user = current_user
    @poll = Poll.where(group_id: @group.id)

    @recent_announc = Announcement.where(group_id: @group.id).last(7).reverse

    #notification
    @current_groupuser = GroupUser.find_by(group_id: @group.id, user_id: @user.id)
    #variable to pass to assets/javascripts/full_calendar.js.erb
    @current_groupuser_admin = GroupUser.find_by(group_id: @group.id, user_id: @user.id).admin


  end

  def announcement
    one_announcement = Announcement.new
    one_announcement.group_id = params[:group_id]
    one_announcement.title = params[:announc_title]
    one_announcement.content = params[:announc_content]
    one_announcement.save



    #notify
    GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).find_each do |one_member|

      #who when what
      one_announcement_notification = Annnoti.new
      one_announcement_notification.group_id = params[:group_id]
      one_announcement_notification.sender = current_user.id
      one_announcement_notification.receiver = one_member.user_id
      one_announcement_notification.content = params[:announc_content]
      one_announcement_notification.save

      #number of notification
      @notify = one_member.ann_notification + 1
      GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).update(:ann_notification => @notify)
    end

    redirect_to :back
  end

  def announcement_all
    @group = Group.find(params[:group_id])
    @announcement_all = Announcement.where(group_id: @group.id)

  end

  def money_plus
    puts 1
    puts 1
    puts 1
    puts 1
    #Find the value of previous budget balance
    @old_budget = Budget.find(params[:group_id]).group_budget
    #How much to add
    @money_plus = params[:money_plus]
    #Change to integer
    @new_budget = @money_plus.to_f + @old_budget.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)
    # Add new transaction to DB
    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_plus]
    one_transaction.description = params[:description_p]
    one_transaction.save

    #notify
    GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).find_each do |one_member|

      #who when what
      one_budget_notification = Budgetnoti.new
      one_budget_notification.group_id = params[:group_id]
      one_budget_notification.sender = current_user.id
      one_budget_notification.receiver = one_member.user_id
      one_budget_notification.content = params[:description_p]
      one_budget_notification.save

      @notify = one_member.budget_notification + 1
      GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).update(:budget_notification => @notify)
    end

  end

  def money_minus
    #Find the value of previous budget balance
    @old_budget = Budget.find(params[:group_id]).group_budget
    #How much to subtract
    @money_minus = params[:money_minus]
    # Change to float
    @new_budget =  @old_budget.to_f - @money_minus.to_f

    Budget.update(params[:group_id], :group_budget => @new_budget)
    # Add new transaction to DB
    one_transaction = Transaction.new
    one_transaction.budget_id = Budget.find(params[:group_id]).id
    one_transaction.value = params[:money_minus]
    one_transaction.description = params[:description_m]
    one_transaction.pos_neg = false
    one_transaction.save

    #notify
    GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).find_each do |one_member|

      #who when what
      one_budget_notification = Budgetnoti.new
      one_budget_notification.group_id = params[:group_id]
      one_budget_notification.sender = current_user.id
      one_budget_notification.receiver = one_member.user_id
      one_budget_notification.content = params[:description_m]
      one_budget_notification.save

      @notify = one_member.budget_notification + 1
      GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).update(:budget_notification => @notify)
    end

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
    one_poll.anonymous = params[:anonymous]
    #one_poll.closing_time = params[:closing_time].to_time.strftime("%m/%d/%Y %I:%M %p")
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

    #notify
    GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).find_each do |one_member|

      #who when what
      one_poll_notification = Pollnoti.new
      one_poll_notification.group_id = params[:group_id]
      one_poll_notification.sender = current_user.id
      one_poll_notification.receiver = one_member.user_id
      one_poll_notification.content = params[:poll_title]
      one_poll_notification.save

      @notify = one_member.poll_notification + 1
      GroupUser.where(group_id: params[:group_id]).where.not(user_id: current_user.id).update(:poll_notification => @notify)
    end

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

  def ann_read
    GroupUser.find_by(group_id: params[:group_id], user_id: current_user.id).update(:ann_notification => 0)
  end

  def cal_read
    GroupUser.find_by(group_id: params[:group_id], user_id: current_user.id).update(:cal_notification => 0)
  end

  def budget_read
    GroupUser.find_by(group_id: params[:group_id], user_id: current_user.id).update(:budget_notification => 0)
  end

  def poll_read
    GroupUser.find_by(group_id: params[:group_id], user_id: current_user.id).update(:poll_notification => 0)
  end



end
