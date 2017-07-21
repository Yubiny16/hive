class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    if $type == 1
      @events = Event.where(start: params[:start]..params[:end], user_id: $group_id, calendar_type: 1)

    end

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
    @event = Event.new(event_params)
    if $type == 1# group
      @event.user_id = $group_id
    else# user
      @event.user_id = current_user.id
    end
    @event.calendar_type = $type
    @event.save

    if $type == 1
      GroupUser.where(group_id: $group_id).find_each do |one_member|

        #Cal Feed
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
    @event.destroy
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :description)
    end
end
