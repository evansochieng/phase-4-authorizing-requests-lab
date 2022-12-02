class MembersOnlyArticlesController < ApplicationController
  # run before the actions
  before_action :unauthorized_access
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  #check for membership
  def unauthorized_access
    render json: {"error": "Not authorized"}, status: :unauthorized unless session.include? :user_id
  end

end
