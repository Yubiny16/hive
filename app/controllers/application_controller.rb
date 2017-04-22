class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #protect_from_forgery with: :exception
  before_filter :count_request
  def require_login
    unless user_signed_in?
      redirect_to "/users/sign_in"
    end
  end
  def count_request
      
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :school, :class_year, :major, :company)}
    devise_parameter_sanitizer.permit(:edit) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :school, :class_year, :major, :company)}
  end
end
