class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.where(user_id: @user.id)
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(tasks_params)
    @task.user_id = @user.id
    @task.author_id = current_user.id

    if @task.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.prepend("task-list", @task),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @task.user_id = @user.id
    @task.author_id = current_user.id

    if @task.update(tasks_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@task, @task),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@task),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def tasks_params
    params.require(:task).permit(:title, :description, :link, :due_date)
  end
end
