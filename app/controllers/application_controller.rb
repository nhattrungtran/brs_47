class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  def correct_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:warning] = t "app.controllers.record_not_exist"
      redirect_to root_path
    end
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "app.controllers.application.pleaselogin"
      redirect_to login_url
    end
  end
end
