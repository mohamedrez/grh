class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update]
  before_action :set_user_request, only: %i[index edit create update]

  def index
    @comments = Comment.where(user_request_id: @user_request.id)
  end

  def edit
    @author = User.find(@comment.author_id)
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    @comment.user_request_id = @user_request.id

    if @comment.save
      redirect_to comments_url(user_request_id: @user_request.id), notice: t("flash.successfully_created")
    else
      redirect_to comments_url(user_request_id: @user_request.id), alert: t("flash.comment_cant_be_blank")
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to comments_url(user_request_id: @user_request.id), notice: t("flash.successfully_updated")
    else
      redirect_to comments_url(user_request_id: @user_request.id), alert: t("flash.comment_cant_be_blank")
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_user_request
    @user_request = UserRequest.find(params[:user_request_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_request_id, :author_id)
  end
end
