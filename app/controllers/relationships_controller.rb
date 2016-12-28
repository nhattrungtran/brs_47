class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    unless @user
      flash[:warning] = t "app.not_exits"
      redirect_to root_url
    end
    current_user.follow @user
    respond_to do |format|
      format.json do
        render json: {status: Settings.status_respone}
      end
    end
  end
end
