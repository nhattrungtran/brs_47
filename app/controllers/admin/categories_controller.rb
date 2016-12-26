class Admin::CategoriesController < ApplicationController
  before_action :verify_admin_access?
  before_action :load_category, except: [:index, :new, :create]

  def index
    @categories = Category.show_category_desc.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "admin_book"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = "Category updated"
      redirect_to admin_category_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.success_destroyed_category"
      redirect_to admin_category_path
    else
      flash[:success] = t "admin.unsuccess_destroyed_category"
      redirect_to admin_category_path
    end
  end

  private
  def category_params
    params.require :category.permit :name
  end

  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "admin.cant_find_category"
      redirect_to admin_category_path
    end
  end
end
