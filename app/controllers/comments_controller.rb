class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_user_request, only: %i[index edit destroy]

  def index
    @comments = Comment.where(user_request_id: @user_request.id)
  end

  def edit
    @author = User.find(@comment.author_id)
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to comments_url(user_request_id: @comment.user_request_id), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user_request = UserRequest.find(params[:comment][:user_request_id])
    if @comment.update(comment_params)
      redirect_to comments_url(user_request_id: @comment.user_request_id), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to comments_url(user_request_id: @comment.user_request_id), notice: t("flash.successfully_destroyed")
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
