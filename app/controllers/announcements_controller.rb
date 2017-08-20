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

    #email
    if params[:post] == "post_and_email"

      mg_client = Mailgun::Client.new("key-01cab085b877b33e7e23683b611974b2")

      message_params =  {
                         from: "#{current_user.first_name} #{current_user.last_name}@synced.space",
                         to:   @announcement.email,
                         subject: @announcement.title,
                         text:    ActionView::Base.full_sanitizer.sanitize(@announcement.content)
                        }

      result = mg_client.send_message('synced.space', message_params).to_h!

      message_id = result['id']
      message = result['message']
    end
  end

  private
  def announcement_params
    params.require(:announcement).permit!
  end
end
