class Api::V1::SalePostsController < ApplicationController
  before_action :find_sale_post, only: [:show, :destroy, :update]
  skip_before_action :authorized, only: %i[create index show destroy]

  def index
    # @sale_posts = SalePost.all.includes(:sale_categories, :comments).find_by id: params[:id]
    @sale_posts = SalePost.all

    render json: @sale_posts
    # @sale_posts = SalePost.all.find_by id: params[:id]

    # render @sale_posts.to_json{:include => [:sale_categories, :comments]}
    # render json: { sale_posts: SalePost.all}, include: [:sale_categories,:comments]
  end

  def new
    @sale_post = SalePost.create
  end

  def show
    @sale_post = SalePost.all.find_by id: params[:id]
    # @sale_post = SalePost.find(params[:id])
    render json: @sale_post
  end

  def create
    @sale_post = SalePost.create(sale_post_params)
    render json: {sale_post: @sale_post}
  end

  def update
    # @sale_post = SalePost.find(params[:id])
    @sale_post.update(sale_post_params)
    if @sale_post.save
      render json: @sale_post, status: :accepted
    else
      render json: { errors: @sale_post.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def destroy
    # @post = post.find(params[:id])
    @sale_post.destroy
    render json: @sale_post, status: :accepted
  end

  private

  def sale_post_params
    params.permit(:name, :picture_url, :user_id, :price)
  end

  def find_sale_post
    @sale_post = SalePost.find(params[:id])
  end
end
