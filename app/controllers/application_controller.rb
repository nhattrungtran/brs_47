class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
