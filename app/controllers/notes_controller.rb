class NotesController < ApplicationController
  before_action :set_note, only: [:edit, :update, :destroy]
  before_action :set_user

  def index
    @notes = Note.where(user_id: @user.id)
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = @user.id
    @note.author_id = current_user.id

    if @note.save
      redirect_to user_notes_path(params[:user_id]), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    note_params[:user_id] = params[:user_id]
    if @note.update(note_params)
      redirect_to user_notes_path(@user), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to user_notes_path(@user), notice: t("flash.successfully_destroyed")
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
