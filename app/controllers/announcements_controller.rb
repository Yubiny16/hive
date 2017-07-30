class AnnouncementsController < ApplicationController
  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.create(announcement_params)

    GroupUser.where(group_id: $group_id).find_each do |one_member|
      #who when what
      one_announcement_notification = Annnoti.new
      one_announcement_notification.notification_type = 1 #announcement
      one_announcement_notification.announcement_id = @announcement.id
      one_announcement_notification.group_id = $group_id
      one_announcement_notification.sender = current_user.id
      one_announcement_notification.receiver = one_member.user_id
      one_announcement_notification.title = @announcement.title
      one_announcement_notification.content = @announcement.content
      one_announcement_notification.save

    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private
  def announcement_params
    params.require(:announcement).permit!
  end
end
