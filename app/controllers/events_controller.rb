class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end], group_id: $group_id)
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
    @event.group_id = $group_id
    @event.save

    GroupUser.where(group_id: $group_id).where.not(user_id: current_user.id).find_each do |one_member|
      @notify = one_member.ann_notification + 1
      GroupUser.where(group_id: $group_id).where.not(user_id: current_user.id).update(:cal_notification => @notify)
    end

  end

  def update
    @event.update(event_params)
    GroupUser.where(group_id: $group_id).where.not(user_id: current_user.id).find_each do |one_member|
      @notify = one_member.ann_notification + 1
      GroupUser.where(group_id: $group_id).where.not(user_id: current_user.id).update(:cal_notification => @notify)
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
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :group_id)
    end
end
