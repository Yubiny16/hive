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
    #unless @announcement.email == nil
    #  mg_client = Mailgun::Client.new("")

    #  message_params =  {
    #                     from: 'bob@example.com',
    #                     to:   @announcement.email,
    #                     subject: @announcement.title,
    #                     text:    @announcement.content
    #                    }

    #  result = mg_client.send_message('sandbox3d5ecb84ef964c55a076e27ff9d3c2f5.mailgun.org', message_params).to_h!

    #  message_id = result['id']
    #  message = result['message']
    #end
  end

  private
  def announcement_params
    params.require(:announcement).permit!
  end
end
