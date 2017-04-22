class RoomsController < ApplicationController
  before_action :require_login
  def show
    @messages = Message.all
    @user = current_user
  end
  def new
    puts params[:group_id]
    puts params[:new_message]
    @new_conversation = Conversation.new
    @new_conversation.userA_email = current_user.email
    @new_conversation.userB_email = params[:friend_email]
    @new_conversation.group_id = params[:group_id]
    @new_conversation.save
    redirect_to :back
  end
end
