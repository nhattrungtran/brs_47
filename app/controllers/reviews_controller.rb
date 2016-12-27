class ReviewsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :load_book, only: :create

  def create
    @review = @book.reviews.build review_params
    unless @review.save
      flash[:warning] = t "app.controllers.reviews.error_save"
      redirect_back fallback_location: root_path
    end
    redirect_back fallback_location: :back
  end

  private
  def review_params
    params.require(:review).permit(:title, :content)
      .merge! user_id: current_user.id
  end

  def load_book
    @book = Book.find_by id: params[:book_id]
    unless @book
      flash[:warning] = t "app.controllers.books.not_found"
      redirect_to books_url
    end
  end
end
