class CommentsController < ApplicationController
  def index
    @user_request = UserRequest.find(params[:user_request_id])
    @comments = Comment.where(user_request_id: @user_request.id)
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to comments_url(user_request_id: @comment.user_request_id), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_request_id, :author_id)
  end
end
