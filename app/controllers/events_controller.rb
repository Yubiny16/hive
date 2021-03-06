class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    #group calendar
    if $type == 1
      @events = Event.where(start: params[:start]..params[:end], user_id: $group_id, calendar_type: 1)

    end

    #my calendar
    if $type == 0
      @events = Event.where(start: params[:start]..params[:end], user_id: current_user.id, calendar_type: 0)

    end

  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create

    if $type == 1# group
      @event = Event.new(event_params)
      @event.user_id = $group_id
      @event.event_type = 1
      @event.calendar_type = $type
      @event.save

      GroupUser.where(group_id: $group_id).find_each do |one_member|

        #Cal notification
        @my_calnoti = Calnoti.new
        @my_calnoti.event_id = @event.id
        @my_calnoti.group_id = $group_id
        @my_calnoti.sender = current_user.id
        @my_calnoti.receiver = one_member.user_id
        @my_calnoti.title = @event.title
        @my_calnoti.description = @event.description
        @my_calnoti.start = @event.start
        @my_calnoti.end = @event.end
        @my_calnoti.save

        #for synced users
        if one_member.sync == true
          one_event = Event.new
          one_event.event_id = @event.id
          one_event.calendar_type = 0
          one_event.event_type = 1
          one_event.user_id = one_member.user_id
          one_event.title = @event.title
          one_event.description = @event.description
          one_event.start = @event.start
          one_event.end = @event.end

          if one_member.color == 'red'
            one_event.color = '#e60000'
          elsif one_member.color == 'orange'
            one_event.color = '#ffa64d'
          elsif one_member.color == 'yellow'
            one_event.color = '#ffdb4d'
          elsif one_member.color == 'green'
            one_event.color = '#77b756'
          elsif one_member.color == 'blue'
            one_event.color = '#2f77c0'
          elsif one_member.color == 'skyblue'
            one_event.color = '#66d9ff'
          elsif one_member.color == 'purple'
            one_event.color = '#aa80ff'
          end

          one_event.save

          one_eventuser = Eventuser.new
          one_eventuser.user_id = one_member.user_id
          one_eventuser.event_id = @event.id
          one_eventuser.save
        end

      end

    else# user

        @event = Event.new(event_params)
        @event.user_id = current_user.id
        @event.event_type = 0
        @event.calendar_type = $type
        @event.save

        @my_calnoti = Calnoti.new
        @my_calnoti.event_id = @event.id
        @my_calnoti.group_id = 0
        @my_calnoti.sender = current_user.id
        @my_calnoti.receiver = current_user.id
        @my_calnoti.title = @event.title
        @my_calnoti.description = @event.description
        @my_calnoti.start = @event.start
        @my_calnoti.end = @event.end
        @my_calnoti.save  

    end

  end

  def update
    @event.update(event_params)

    if $type == 1

      #delete previous cal Feed
      Calnoti.where(event_id: @event.id).destroy_all()

      GroupUser.where(group_id: $group_id).find_each do |one_member|

        Event.where(event_id: @event.id).where(calendar_type: 0).where(user_id: one_member.user_id).destroy_all()

        #New Cal Feed
        one_cal_notification = Calnoti.new
        one_cal_notification.event_id = @event.id
        one_cal_notification.group_id = $group_id
        one_cal_notification.sender = current_user.id
        one_cal_notification.receiver = one_member.user_id
        one_cal_notification.title = @event.title
        one_cal_notification.description = @event.description
        one_cal_notification.start = @event.start
        one_cal_notification.end = @event.end
        one_cal_notification.save

      end
    end
  end

  def destroy

    if $type == 1
      Calnoti.where(event_id: @event.id).destroy_all
      Eventuser.where(event_id: @event.id).destroy_all
      Event.where(event_id: @event.id).destroy_all
      @event.destroy
    end

    if $type == 0
      @event.destroy
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :description)
    end
end
