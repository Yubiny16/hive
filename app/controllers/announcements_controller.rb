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
      one_announcement_notification.group_id = params[:group_id]
      one_announcement_notification.sender = current_user.id
      one_announcement_notification.receiver = one_member.user_id
      one_announcement_notification.title = params["announcement[title]"]
      one_announcement_notification.content = params["announcement[content]"]
      one_announcement_notification.save

    end
    redirect_to :back
  end

  private
  def announcement_params
    params.require(:announcement).permit!
  end
end
# <form action="/home/announcement" method="get">
#   <label>Title</label>
#   <input name="announcement_title" type="text" class="form-control"/>
#   <label>Content</label>
#   <input id="announcement_content" type="hidden" name="announcement_content"/>
#   <trix-editor input="announcement_content"></trix-editor>
#   <label>Email</label>
#   <input name="announcement_email" type="email" value="<%= @group.email %>" class="form-control"/>
#   <input name="group_id" type="hidden" value="<%= @group.id %>">
#   <div class="popup-buttons">
#     <button name="post" value= "no_email" type="submit" class="btn">Post</button>
#     <button name="post" value= "send_email" type="submit" class="btn">Post and Send Email</button>
#   </div>
# </form>
