class GoalsController < ApplicationController
  before_action :set_goal, only: %i[show edit update end_goal archive]
  before_action :set_owner, only: %i[show edit]

  def index
    @goals = Goal.where(archived: false)
  end

  def show
  end

  def new
    @goal = Goal.new
  end

  def edit
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.author_id = current_user.id

    if @goal.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("goal-list", @goal),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@goal, @goal),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def end_goal
    @end_goal_description = params[:goal][:end_goal_description]
    @status = params[:goal][:status]

    if @goal.update!(end_goal_description: @end_goal_description, status: @status)
      redirect_to goals_path, notice: t("flash.successfully_end_goal")
    else
      redirect_to goal_path(@goal), alert: t("flash.must_have_description")
    end
  end

  def archive
    @goal.update!(archived: true)
    redirect_to goals_path, notice: t("flash.successfully_archived")
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def set_owner
    @owner = @goal.owner
  end

  def goal_params
    params.require(:goal).permit(:title, :owner_id, :status, :start_date, :due_date, :description, :level)
  end
end
