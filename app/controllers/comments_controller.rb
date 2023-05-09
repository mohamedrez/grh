class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update]
  before_action :set_commentable, only: %i[index create]

  def index
    @comments = Comment.where(commentable_type: @commentable_type, commentable_id: @commentable_id)
    @url = "/comments?commentable_type=#{@commentable_type}&commentable_id=#{@commentable_id}"
  end

  def edit
    @author = User.find(@comment.author_id)
    @commentable_type = @comment.commentable_type
    @commentable_id = @comment.commentable_id
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    @comment.commentable_type = @commentable_type
    @comment.commentable_id = @commentable_id
    @url = "/comments/#{@comment.id}?commentable_type=#{@commentable_type}&commentable_id=#{@commentable_id}"

    if @comment.save
      redirect_to comments_url(commentable_type: @commentable_type, commentable_id: @commentable_id), notice: t("flash.successfully_created")
    else
      redirect_to comments_url(commentable_type: @commentable_type, commentable_id: @commentable_id), alert: t("flash.comment_cant_be_blank")
    end
  end

  def update
    @commentable_type = @comment.commentable_type
    @commentable_id = @comment.commentable_id

    if @comment.update(comment_params)
      redirect_to comments_url(commentable_type: @commentable_type, commentable_id: @commentable_id), notice: t("flash.successfully_updated")
    else
      redirect_to comments_url(commentable_type: @commentable_type, commentable_id: @commentable_id), alert: t("flash.comment_cant_be_blank")
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable_type = params[:commentable_type]
    @commentable_id = params[:commentable_id]
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
