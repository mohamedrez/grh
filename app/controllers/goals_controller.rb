class GoalsController < ApplicationController
  before_action :set_goal, only: %i[show edit update end_goal archive]
  before_action :set_users_select
  before_action :set_owner, only: %i[show edit]
  before_action :set_breadcrumbs, only: %i[index show objectives]
  before_action :set_authorization, only: %i[new create edit update archive]

  def index
    user_id = params[:user_id]
    @q = Goal.ransack(params[:q])

    @goals = if user_id
      @user = User.find(user_id)
      @q.result(distinct: true).where(owner_id: user_id, archived: false)
    else
      authorized_scope(@q.result(distinct: true).where(archived: false))
    end
  end

  def show
    authorize! @goal
    @end_goal_errors = params[:end_goal_errors] || {}
    @end_goal_description = params[:end_goal_description]
    @status = params[:status]

    add_breadcrumb(@goal.title)
  end

  def new
    @goal = Goal.new
  end

  def edit
    @from_view = params[:from_view]
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.author_id = current_user.id

    if @goal.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("goal-list", @goal),
        turbo_stream.replace("summary-stats", partial: "goals/summary_stats"),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @from_view = params[:from_view]
    if @goal.update(goal_params)
      flash.now[:notice] = t("flash.successfully_updated")

      if @from_view == "index"
        render turbo_stream: [
          turbo_stream.replace(@goal, @goal),
          turbo_stream.replace("right", partial: "shared/right"),
          turbo_stream.replace("notification_alert", partial: "layouts/alert")
        ]
      elsif @from_view == "show"
        render turbo_stream: [
          turbo_stream.replace(@goal, partial: "goals/show_partial", locals: {owner: @goal.owner, goal: @goal, end_goal_errors: {}}),
          turbo_stream.replace("right", partial: "shared/right"),
          turbo_stream.replace("notification_alert", partial: "layouts/alert")
        ]
      end

    else
      render :edit, status: :unprocessable_entity
    end
  end

  def end_goal
    end_goal_description = params[:goal][:end_goal_description]
    status = params[:goal][:status]

    end_goal_errors = {}
    end_goal_errors[:end_goal_description] = t("errors.end_goal_description") if end_goal_description.blank?
    end_goal_errors[:status] = t("errors.should_provide_status") if Goal.statuses.map { |key, value| key }.exclude?(status)

    if end_goal_errors.blank? && @goal.update!(end_goal_description: end_goal_description, status: status)
      redirect_to goal_path(@goal), notice: t("flash.goal_successfully_ended")
    else
      redirect_to goal_path(@goal, end_goal_errors: end_goal_errors, end_goal_description: end_goal_description, status: status)
    end
  end

  def archive
    @goal.update!(archived: true)

    @from_view = params[:from_view]
    if @from_view == "index"
      flash.now[:notice] = t("flash.successfully_archived")
      render turbo_stream: [
        turbo_stream.remove(@goal),
        turbo_stream.replace("summary-stats", partial: "goals/summary_stats"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    elsif @from_view == "show"
      redirect_to goals_path, notice: t("flash.successfully_archived")
    end
  end

  def objectives
    user_id = params[:user_id]
    @year = params[:year]
    @user = User.find_by(id: user_id)
    add_breadcrumb(@year)
    add_breadcrumb(@user.full_name)
    render status: :not_found unless @user

    @goals = Goal.where(owner_id: user_id, archived: false)
      .where("extract(year from due_date) = ?", @year)

    @completion_factor_sum = Goal.completion_factor_sum(@goals)
    @importance_factor_sum = Goal.importance_factor_sum(@goals)
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def set_owner
    @owner = @goal.owner
  end

  def set_authorization
    authorize!
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.goals.title_goals"), goals_path)
  end

  def set_users_select
    users = User.all
    users = User.where(manager_id: current_user.id) unless current_user.has_any_role?([:hr, :admin])
    @users_select = users.map { |user| [user.full_name, user.id] }
  end

  def goal_params
    params.require(:goal).permit(:title, :owner_id, :status, :start_date, :due_date, :description, :level)
  end
end
