class Admin::BooksController < ApplicationController
  before_action :verify_admin_access?
  before_action :book_find_by, except: [:index, :new, :create]

  def index
    @books = Book.filter_newest.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:success] = t "admin.books.created_book"
      redirect_to admin_books_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update book_params
      flash[:success] = t "admin.books.updated_book"
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = t "admin.books.deleted_book"
    else
      flash[:success] = t "admin.books.undeleted_book"
    end
    redirect_to admin_book_path
  end

  private
  def book_params
    params.require(:book).permit :title, :description, :publish_date, :author, :image,
      :page, :rating, :category_id
  end

  def load_book
    @book = Book.find_by id: params[:id]
    unless @book
      flash[:danger] = t "admin.cant_found_book"
      redirect_to admin_book_path
    end
  end
end
