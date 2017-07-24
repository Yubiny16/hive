require 'mailgun'
class HomeController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  $n = 2
  $type
  $timezone

  def index
    @user = current_user

    @current_group_user = GroupUser.where(user_id: @user.id)

    @ann_notification = Annnoti.where(receiver: @user.id)
    @poll_notification = Pollnoti.where(receiver: @user.id)

    @all_notification = (@poll_notification + @ann_notification).sort{|a,b| a.created_at <=> b.created_at }.reverse

    
    puts $timezone
    puts 1
    puts 1
  end

  def search
    @user_groups = GroupUser.where(user_id: current_user.id)
    if params[:search_group] == ""
      @search = "dldksjflk;asjfldsjfcmvlkxvnl9reut"

    else
      @search = params[:search_group]

    end

    @searched_groups = Group.where("name LIKE ?", "%#{@search}%")

  end

  def profile
    @user = current_user
    @user_groups = GroupUser.where(user_id: @user.id)
  end

  def group_color
    GroupUser.where(user_id: current_user.id).where(group_id: params[:group_id]).update(:color => params[:new_color])
  end

  def profile_update
    User.update(current_user.id, :first_name => params[:user_first_name])
    User.update(current_user.id, :last_name => params[:user_last_name])
    User.update(current_user.id, :school => params[:user_school])
    User.update(current_user.id, :major => params[:user_major])
    User.update(current_user.id, :class_year => params[:user_class_year])

    uploader = UserprofileUploader.new
    uploader.store!(params[:pic])

    @user = current_user
    @user.image_url = uploader.url
    @user.save

    redirect_to "/home/profile"
  end

  # def uploadprofpic
  #   uploader = UserprofileUploader.new
  #   uploader.store!(params[:pic])
  #
  #   @user = current_user
  #   @user.image_url = uploader.url
  #   @user.save
  #
  #   redirect_to "/home/profile"
  # end

  def create_group_view
    @user_groups = GroupUser.where(user_id: current_user.id)

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
    one_group.description = params[:group_description]
    one_group.email = params[:group_email]
    one_group.password = params[:group_pw]
    one_group.website_address = params[:group_website]
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
    $type = 1
    @user = current_user
    @poll = Poll.where(group_id: @group.id).reverse
    @budget = Budget.find_by(group_id: @group.id)

    @announcements = Announcement.where(group_id: @group.id).reverse
    @user_groups = GroupUser.where(user_id: @user.id)

    @admin_user = GroupUser.find_by(group_id: @group.id, user_id: @user.id)

    #variable to pass to assets/javascripts/full_calendar.js.erb
    #@current_groupuser_admin = GroupUser.find_by(group_id: @group.id, user_id: @user.id).admin

    #Member
    @members = GroupUser.where(group_id: @group.id)

    #poll not voted
    @number_of_notvoted = 0

    puts $timezone
    puts 1
    puts 1
  end

  def group_profile
    @user_groups = GroupUser.where(user_id: current_user.id)
    @group = Group.find_by_id(params[:group_id])
    @admin_user = GroupUser.find_by(group_id: @group.id, user_id: current_user.id)
  end

  def group_edit
    group_id = params[:group_id]
    Group.update(params[:group_id], :name => params[:group_name])
    Group.update(params[:group_id], :school => params[:group_school])
    Group.update(params[:group_id], :description => params[:group_description])
    Group.update(params[:group_id], :password => params[:group_pw])
    Group.update(params[:group_id], :website_address => params[:group_website])

    uploader = GroupprofileUploader.new
    uploader.store!(params[:pic])

    Group.update(params[:group_id], :image_url => uploader.url)

    redirect_to "/home/group_page/#{group_id}"
  end

  def announcement
    one_announcement = Announcement.new
    one_announcement.group_id = params[:group_id]
    one_announcement.title = params[:announcement_title]
    one_announcement.content = params[:announcement_content]
    one_announcement.email = params[:announcement_email]
    one_announcement.save

    #notify
    GroupUser.where(group_id: params[:group_id]).find_each do |one_member|

      #who when what
      one_announcement_notification = Annnoti.new
      one_announcement_notification.notification_type = 1 #announcement
      one_announcement_notification.announcement_id = one_announcement.id
      one_announcement_notification.group_id = params[:group_id]
      one_announcement_notification.sender = current_user.id
      one_announcement_notification.receiver = one_member.user_id
      one_announcement_notification.title = params[:announcement_title]
      one_announcement_notification.content = params[:announcement_content]
      one_announcement_notification.save

    end

    #if params[:post] == 'send_email'

    #  @from = Group.find(params[:group_id]).name + params[:group_id] + '@hive.net'
    #  @group_email = params[:group_email]
    #  @title = params[:title]
    #  @content = params[:content]

    #  mg_client = Mailgun::Client.new("key-01cab085b877b33e7e23683b611974b2")

    #  message_params =  {
    #                     from: 'master@likelion.net',
    #                     to:   'yubiny16@gmail.com',
    #                     subject: '@title',
    #                     text:    '@content'
    #                    }

    #  result = mg_client.send_message("sandbox3d5ecb84ef964c55a076e27ff9d3c2f5.mailgun.org", message_params).to_h!

    #  message_id = result['id']
    #  message = result['message']
    #end

    redirect_to :back
  end

  def announcement_all
    @group = Group.find(params[:group_id])
    @announcement_all = Announcement.where(group_id: @group.id)
  end

  def send_email
    mg_client = Mailgun::Client.new("your-api-key")

    message_params =  {
                       from: 'bob@example.com',
                       to:   'sally@example.com',
                       subject: 'The Ruby SDK is awesome!',
                       text:    'It is really easy to send a message!'
                      }

    result = mg_client.send_message('example.com', message_params).to_h!

    message_id = result['id']
    message = result['message']
  end

  def money_plus
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
    GroupUser.where(group_id: params[:group_id]).find_each do |one_member|

      #who when what
      one_poll_notification = Pollnoti.new
      one_poll_notification.notification_type = 2 #announcement
      one_poll_notification.group_id = params[:group_id]
      one_poll_notification.poll_id = one_poll.id
      one_poll_notification.sender = current_user.id
      one_poll_notification.receiver = one_member.user_id
      one_poll_notification.title = params[:poll_title]
      one_poll_notification.save

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


  def ann_read
    Annnoti.find(params[:ann_notification_id]).update(:read => true)
  end

  def cal_read
    Calnoti.find(params[:cal_notification_id]).update(:read => true)
  end

  def poll_read
    Pollnoti.find(params[:poll_notification_id]).update(:read => true)
  end

  #####my_calendar

  def my_calendar
    @current_group_user = GroupUser.where(user_id: current_user.id)
    @cal_notification = Calnoti.where(receiver: current_user.id).reverse
    $type = 0
  end

  def add_event
    one_event = Event.new
    one_event.event_id = params[:event_id]
    one_event.calendar_type = 0
    one_event.event_type = 1
    one_event.user_id = current_user.id
    one_event.title = params[:title]
    one_event.description = params[:description]
    one_event.start = params[:start]
    one_event.end = params[:end]
    one_event.color = params[:color]
    one_event.save

    one_event_user = Eventuser.new
    one_event_user.user_id = current_user.id
    one_event_user.event_id = params[:event_id]
    one_event_user.save

    redirect_to :back
  end
  def cancel_event
    Event.where(event_id: params[:event_id]).where(calendar_type: 0).where(user_id: current_user.id).destroy_all()
    Eventuser.find_by(event_id: params[:event_id], user_id: current_user.id).destroy
    redirect_to :back
  end

  def file_upload
    gfiles = Groupfile.new
    gfiles.group_id = params[:group_id]
    # gfiles.filename = original_filename

    uploader = GroupfileUploader.new
    uploader.store!(params[:file])

    gfiles.file_url = uploader.url

    redirect_to :back
  end


end
