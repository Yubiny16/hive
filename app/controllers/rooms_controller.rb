class RoomsController < ApplicationController
  before_action :require_login
  def show
    session[:conversations] ||= []
      @users = User.all.where.not(id: current_user)
      @user_conversations = Conversation.all.where(recipient_id: current_user.id).or(Conversation.where(sender_id: current_user.id))
      @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
  end
  def new
    @new_conversation = Conversation.new
    @new_conversation.recipient_id = current_user.id
    @new_conversation.sender_id = params[:friend_id]
    @new_conversation.save
    redirect_to :back
  end
end
