class BooksController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  before_action :load_book, only: :show

  def index
    @books = Book.filter_newest.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
    if logged_in?
      @review = @book.reviews.build
    end
    @reviews = @book.reviews.includes(:user, comments: :user).newest
      .paginate page: params[:page], per_page: Settings.per_page
  end

  private
  def load_book
    @book = Book.find_by id: params[:id]
    unless @book
      flash[:warning] = t "app.controllers.error_not_exits"
      redirect_to root_url
    end
  end
end
