class MissionOrdersController < ApplicationController
  before_action :set_user, except: [:index, :destroy]
  before_action :set_mission_order, except: %i[index new create]

  def index
    user_id = params[:user_id]
    if user_id
      @user = User.find(user_id)
      ids = UserRequest.where(user_id: @user.id, requestable_type: "MissionOrder").pluck(:requestable_id)
      @mission_orders = MissionOrder.where(id: ids)
      @for = "user"
      add_breadcrumb(t("views.layouts.main.my_requests"), user_time_requests_path(@user))
    elsif request.path.include?("team")
      ids = UserRequest.joins(:user)
        .where(users: {manager_id: current_user.id})
        .where(requestable_type: "MissionOrder")
        .pluck(:requestable_id)

      @mission_orders = MissionOrder.where(id: ids)
      @for = "team"
      add_breadcrumb(t("views.layouts.main.team_requests"), team_time_requests_path)
    else
      @mission_orders = MissionOrder.all
      @for = "all"
      add_breadcrumb(t("views.layouts.main.requests"), time_requests_path)
    end
  end

  def show
    authorize! @mission_order
    @user_request = @mission_order.user_request
    @aasm_logs = AasmLog.where(aasm_logable: @mission_order)

    case params[:for]
    when "user"
      add_breadcrumb(t("views.layouts.main.my_requests"), user_time_requests_path(current_user))
    when "team"
      add_breadcrumb(t("views.layouts.main.team_requests"), team_time_requests_path)
    when "all"
      add_breadcrumb(t("views.layouts.main.requests"), time_requests_path)
    end
    add_breadcrumb(@mission_order.title)
  end

  def new
    @mission_order = MissionOrder.new
  end

  def edit
  end

  def create
    @mission_order = MissionOrder.new(mission_order_params)
    @mission_order.user_id = @user.id

    if @mission_order.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("mission-order-list", @mission_order),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    mission_order_params[:user_id] = @user.id

    if @mission_order.update(mission_order_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@mission_order, @mission_order),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mission_order.destroy

    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@mission_order),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  def update_aasm_state
    next_state = params[:next_state]
    @mission_order.actor_id = current_user.id

    @mission_order.send("#{next_state}!")

    redirect_to user_mission_order_path(@user, @mission_order)
  end

  def new_payment
  end

  def make_payment
    next_state = params[:mission_order][:next_state]
    payment_type = params[:mission_order][:payment_type]

    @mission_order.actor_id = current_user.id
    @mission_order.payment_type = payment_type

    @mission_order.send("#{next_state}!")

    @user_request = @mission_order.user_request
    @aasm_logs = AasmLog.where(aasm_logable: @mission_order)

    flash.now[:notice] = t("flash.payment_was_successful")
    render turbo_stream: [
      turbo_stream.replace(@mission_order, partial: "mission_orders/show_partial", locals: {mission_order: @mission_order, user: @user, user_request: @user_request, aasm_logs: @aasm_logs}),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_mission_order
    @mission_order = MissionOrder.find(params[:id])
  end

  def mission_order_params
    params.require(:mission_order).permit(:title, :start_date, :end_date, :indemnity_type, :accommodation, :mission_type, :location, :site_id, :transport_type, :description, :user_id)
  end
end
