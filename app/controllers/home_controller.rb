require 'mailgun'
class HomeController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  $n = 2
  $type
  $timezone

  def index

    if params[:index_first_time] == "no"
      User.find_by_id(current_user.id).update(:index_first_time => params[:index_first_time])
    end

    #instruction message from hive (main page)
    if User.find_by_id(current_user.id).index_first_time == "yes" && current_user.id != 1
      connectwithhive = GroupUser.new
      connectwithhive.group_id = 1
      connectwithhive.user_id = current_user.id
      connectwithhive.color = "red"
      connectwithhive.save

      hive_announcement = Annnoti.new
      hive_announcement.notification_type = 1
      hive_announcement.announcement_id = Announcement.where(group_id: 1).first.id
      hive_announcement.group_id = 1
      hive_announcement.sender = 1
      hive_announcement.receiver = current_user.id
      hive_announcement.title = Announcement.where(group_id: 1).first.title
      hive_announcement.content = Announcement.where(group_id: 1).first.content
      hive_announcement.save

    end

    @user = current_user

    @current_group_user = GroupUser.where(user_id: @user.id)
    Rails.logger.info "Number of Current User's Groups: #{@current_group_user.count}"
    Rails.logger.info "Total number of groups: #{Group.count}"

    now = (Date.today + 1)
    weekago = (now - 7)

    @ann_notification = Annnoti.where(receiver: @user.id).where(:created_at => weekago.beginning_of_day..now.end_of_day)
    @poll_notification = Pollnoti.where(receiver: @user.id).where(:created_at => weekago.beginning_of_day..now.end_of_day)

    @all_notification = (@poll_notification + @ann_notification).sort{|a,b| a.created_at <=> b.created_at }.reverse

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
    Rails.logger.info "Current User's Groups: #{@user_groups.all}"
  end

  def group_color
    GroupUser.where(user_id: current_user.id).where(group_id: params[:group_id]).update(:color => params[:new_color])
    Event.where(calendar_type: 1).where(event_type: 1).where(user_id: params[:group_id]).each do |event_change_color|
      if params[:new_color] == 'red'
        new_color = '#e60000'
      elsif params[:new_color] == 'orange'
        new_color = '#ffa64d'
      elsif params[:new_color] == 'yellow'
        new_color = '#ffdb4d'
      elsif params[:new_color] == 'green'
        new_color = '#77b756'
      elsif params[:new_color] == 'blue'
        new_color = '#2f77c0'
      elsif params[:new_color] == 'skyblue'
        new_color = '#66d9ff'
      elsif params[:new_color] == 'purple'
        new_color = '#aa80ff'
      end
      Event.where(calendar_type: 0).where(event_type: 1).where(user_id: current_user.id).where(event_id: event_change_color.id).update(:color => new_color)
    end

  end

  def profile_update
    User.update(current_user.id, :first_name => params[:user_first_name])
    User.update(current_user.id, :last_name => params[:user_last_name])
    User.update(current_user.id, :school => params[:user_school])
    User.update(current_user.id, :major => params[:user_major])
    User.update(current_user.id, :class_year => params[:user_class_year])

    uploader = UserprofileUploader.new
    uploader.store!(params[:pic])

    unless uploader.url == nil
      @user = current_user
      @user.image_url = uploader.url
      @user.save
    end

    redirect_to "/home/profile"
  end

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
       one_group_user.color = params[:color]
       one_group_user.save

       redirect_to controller: 'home', action: 'group_page', id: :group_id
     else
       redirect_to :back
       #jquery로 패스워드 틀렸다 말하기
     end

     Event.where(user_id: params[:group_id]).where(calendar_type: 1).each do |event|
       one_calnoti = Calnoti.new
       one_calnoti.event_id = event.id
       one_calnoti.group_id = event.user_id
       one_calnoti.receiver = current_user.id
       one_calnoti.title = event.title
       one_calnoti.description = event.description
       one_calnoti.start = event.start
       one_calnoti.end = event.end
       one_calnoti.save
     end
  end

  def create_group

    if params[:group_name] == "" || params[:group_school] == "" || params[:group_description] == "" || params[:group_pw] == ""
      redirect_to :back
    else

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
      one_group_user.sync = true
      one_group_user.color = params[:color]
      one_group_user.save

      one_group_budget = Budget.new
      one_group_budget.group_id = one_group.id
      one_group_budget.group_budget = 0
      one_group_budget.save

      redirect_to "/home/index"
    end
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

    #files
    @files = Groupfile.where(group_id: @group.id).reverse

    #poll not voted
    @number_of_notvoted = 0

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
    Group.update(params[:group_id], :email => params[:group_email])
    Group.update(params[:group_id], :website_address => params[:group_website])

    uploader = GroupprofileUploader.new
    uploader.store!(params[:pic])
    unless uploader.url == nil
      Group.update(params[:group_id], :image_url => uploader.url)
    end
    redirect_to "/home/group_page/#{group_id}"
  end

  def transaction
    @transaction_type = params[:transaction_type]
    if params[:transaction_type] == "plus"
      #Find the value of previous budget balance
      @old_budget = Budget.find(params[:group_id]).group_budget
      #How much to add
      @money_plus = params[:money]
      #Change to integer
      @new_budget = @money_plus.to_f + @old_budget.to_f

      Budget.update(params[:group_id], :group_budget => @new_budget)
      # Add new transaction to DB
      @one_transaction = Transaction.new
      @one_transaction.budget_id = Budget.find(params[:group_id]).id
      @one_transaction.value = params[:money]
      @one_transaction.description = params[:description]
      @one_transaction.save
    elsif params[:transaction_type] == "minus"
      #Find the value of previous budget balance
      @old_budget = Budget.find(params[:group_id]).group_budget
      #How much to subtract
      @money_minus = params[:money]
      # Change to float
      @new_budget =  @old_budget.to_f - @money_minus.to_f

      Budget.update(params[:group_id], :group_budget => @new_budget)
      # Add new transaction to DB
      @one_transaction = Transaction.new
      @one_transaction.budget_id = Budget.find(params[:group_id]).id
      @one_transaction.value = params[:money]
      @one_transaction.description = params[:description]
      @one_transaction.pos_neg = false
      @one_transaction.save

    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def add_option
    # add option to global variable $n
    $n = $n+1
  end

  def new_poll
    # Create new poll DB
    @one_poll = Poll.new
    @one_poll.group_id = params[:group_id]
    @one_poll.title = params[:poll_title]
    @one_poll.anonymous = params[:anonymous]
    @one_poll.sender = current_user.id
    #one_poll.closing_time = params[:closing_time].to_time.strftime("%m/%d/%Y %I:%M %p")
    @one_poll.save

    # Create new Options
    for i in 1..$n
      new_option = Option.new
      # To see which poll these options belong to
      new_option.poll_id = @one_poll.id
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
      one_poll_notification.poll_id = @one_poll.id
      one_poll_notification.sender = current_user.id
      one_poll_notification.receiver = one_member.user_id
      one_poll_notification.title = params[:poll_title]
      one_poll_notification.save

    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def option_select
    @p_id = params[:poll_id]
    @o_id = params[:optradio]
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

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def option_cancel
    @p_id = params[:poll_id]
    # find the user's vote
    Polluser.where(poll_id: params[:poll_id]).where(user_id: current_user.id).where(voted: true).find do |polluser|
      @option_id = polluser.option_id
      # decrease the number of votes for this option by 1
      @vote_number = Option.find(@option_id).vote_number
      Option.update(@option_id, :vote_number => @vote_number - 1)
      # User's vote has been revoked
      Polluser.update(polluser.id, :voted => false)
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end


  def ann_read
    Annnoti.find(params[:ann_notification_id]).update(:read => true)
  end

  def poll_read
    Pollnoti.find(params[:poll_notification_id]).update(:read => true)
  end

  #####my_calendar

  def my_calendar
    $type = 0 #calendar type   0: my calendar

    @current_group_user = GroupUser.where(user_id: current_user.id)

    now = Date.today

    Calnoti.where(receiver: current_user.id).each do |old_event|
      if Date.strptime(old_event.end.to_s, '%Y-%m-%d') < Date.strptime(now.to_s, '%Y-%m-%d')
        old_event.destroy
      end
    end

    @cal_notification = Calnoti.where(receiver: current_user.id).order(:start)

  end

  def add_event
    @calnoti_id = params[:event_id]
    @one_event = Event.new
    @one_event.event_id = params[:event_id]
    @one_event.calendar_type = 0
    @one_event.event_type = 1
    @one_event.user_id = current_user.id
    @one_event.title = params[:title]
    @one_event.description = params[:description]
    @one_event.start = params[:start]
    @one_event.end = params[:end]
    if params[:color] == 'red'
      @one_event.color = '#e60000'
    elsif params[:color] == 'orange'
      @one_event.color = '#ffa64d'
    elsif params[:color] == 'yellow'
      @one_event.color = '#ffdb4d'
    elsif params[:color] == 'green'
      @one_event.color = '#77b756'
    elsif params[:color] == 'blue'
      @one_event.color = '#2f77c0'
    elsif params[:color] == 'skyblue'
      @one_event.color = '#66d9ff'
    elsif params[:color] == 'purple'
      @one_event.color = '#aa80ff'
    end
    @one_event.save

    one_event_user = Eventuser.new
    one_event_user.user_id = current_user.id
    one_event_user.event_id = params[:event_id]
    one_event_user.save

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def add_event_from_group_page
    event_id = params[:event_id]

    @one_event = Event.new
    @one_event.event_id = event_id
    @one_event.calendar_type = 0
    @one_event.event_type = 1
    @one_event.user_id = current_user.id
    @one_event.title = Event.find(event_id).title
    @one_event.description = Event.find(event_id).description
    @one_event.start = Event.find(event_id).start
    @one_event.end = Event.find(event_id).end
    @one_event.color = GroupUser.find_by(group_id: $group_id, user_id: current_user.id).color
    @one_event.save

    one_event_user = Eventuser.new
    one_event_user.user_id = current_user.id
    one_event_user.event_id = event_id
    one_event_user.save
  end

  def cancel_event_from_group_page
    delete_event = Event.find_by(event_id: params[:event_id], calendar_type: 0, event_type: 1, user_id: current_user.id)
    delete_event.destroy
    Eventuser.find_by(event_id: params[:event_id], user_id: current_user.id).destroy
  end

  def cancel_event
    @calnoti_id = params[:event_id]

    @event_id = Event.find_by(event_id: params[:event_id], calendar_type: 0, event_type: 1, user_id: current_user.id).id
    Event.where(event_id: params[:event_id]).where(calendar_type: 0).where(user_id: current_user.id).where(event_type: 1).destroy_all()
    Eventuser.find_by(event_id: params[:event_id], user_id: current_user.id).destroy


    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def my_event_delete
    @event_id = params[:event_id]
    delete_event = Event.find(params[:event_id])
    delete_event.destroy

    delete_event_noti = Calnoti.find(params[:calnoti_id])
    delete_event_noti.destroy

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def file_upload
    gfiles = Groupfile.new
    gfiles.group_id = params[:group_id]
    gfiles.filename = params[:file_name]
    # gfiles.filename = original_filename

    uploader = GroupfileUploader.new
    uploader.store!(params[:file])

    gfiles.file_url = uploader.url
    gfiles.save

    redirect_to :back
  end

  def destroy_file
    @file = Groupfile.find_by_id(params[:file_id])
    f_url = @file.file_url
    f_key = f_url.partition('syncdataynr/').last
    @file.destroy

    # Aws.use_bundled_cert!
    # s3 = Aws::S3::Client.new
    # s3.delete_object(bucket: 'syncdataynr', key: f_key)

    redirect_to :back
  end

  def destroy_transaction
    @t_id = params[:t_id]
    @trans = Transaction.find_by_id(params[:t_id])
    @old_budget = Budget.find_by(group_id: $group_id).group_budget
    if @trans.pos_neg == true
      @new_budget = @old_budget - @trans.value.to_f
    else
      @new_budget = @old_budget + @trans.value.to_f
    end
    Budget.find_by(group_id: $group_id).update(:group_budget => @new_budget)

    @trans.destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def destroy_announcement
    @ann_id = params[:ann_id]
    @ann = Announcement.find_by_id(params[:ann_id])
    @ann.destroy
    Annnoti.where(announcement_id: params[:ann_id]).destroy_all
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def destroy_poll
    @poll_id = params[:p_id]
    @poll = Poll.find_by_id(params[:p_id])
    @poll.destroy
    Pollnoti.where(poll_id: params[:p_id]).destroy_all
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def appoint_admin
    GroupUser.where(user_id: params[:user_id]).where(group_id: $group_id).update(:admin => true)
    redirect_to :back
  end

  def group_leave
    GroupUser.where(user_id: current_user.id).where(group_id: $group_id).destroy_all
    Annnoti.where(group_id: $group_id).where(receiver: current_user.id).destroy_all
    Pollnoti.where(group_id: $group_id).where(receiver: current_user.id).destroy_all
    Calnoti.where(group_id: $group_id).where(receiver: current_user.id).destroy_all

    Event.where(calendar_type: 1).where(event_type: 1).where(user_id: $group_id).each do |destroy_event|
      Event.where(calendar_type: 0).where(event_type: 1).where(user_id: current_user.id).where(event_id: destroy_event.id).destroy_all
    end

    redirect_to "/home/index"
  end

  def sync
    GroupUser.where(group_id: $group_id).where(user_id: current_user.id).update(:sync => true)
    redirect_to :back
  end

  def unsync
    GroupUser.where(group_id: $group_id).where(user_id: current_user.id).update(:sync => false)
    redirect_to :back
  end

  def invite

    @group_name = Group.find($group_id).name
    @group_pw = Group.find($group_id).password

    unless params[:email1] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email1],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end

    unless params[:email2] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email2],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end

    unless params[:email3] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email3],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end
    unless params[:email4] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email4],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end
    unless params[:email5] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email5],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end
    unless params[:email6] == ""
      mg_client = Mailgun::Client.new("")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   params[:email6],
                         subject: "#{current_user.first_name} #{current_user.last_name} Invited you to join #{@group_name} at Sync",
                         text:    "Join " + @group_name + " at www.synced.space (the password for this group is " + @group_pw + ")"
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end

  redirect_to :back

  end
end
