class MissionOrdersController < ApplicationController
  before_action :set_user, except: [:index, :destroy]
  before_action :set_mission_order, except: %i[index new create]
  before_action :set_breadcrumbs, only: %i[index show]

  def index
    user_id = params[:user_id]
    if user_id
      @user = User.find(user_id)
      ids = UserRequest.where(user_id: @user.id, requestable_type: "MissionOrder").pluck(:requestable_id)
      @mission_orders = MissionOrder.where(id: ids)
    else
      @mission_orders = authorized_scope(MissionOrder.all)
    end
  end

  def show
    @user_request = @mission_order.user_request
    @aasm_logs = AasmLog.where(aasm_logable: @mission_order)
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
    aasm_state = params[:aasm_state]
    @mission_order.actor_id = current_user.id

    case aasm_state
    when "validated_by_manager"
      @mission_order.validate_mission_order_by_manager!
    when "validated_by_hr"
      @mission_order.validate_mission_order_by_hr!
    when "rejected"
      @mission_order.reject_mission_order!
    end

    redirect_to user_mission_order_path(@user, @mission_order)
  end

  def new_payment
  end

  def make_payment
    @user = User.find(params[:user_id])
    @mission_order = MissionOrder.find(params[:id])

    aasm_state = params[:mission_order][:aasm_state]
    payment_type = params[:mission_order][:payment_type]

    @mission_order.actor_id = current_user.id
    @mission_order.payment_type = payment_type

    case aasm_state
    when "paid_by_accountant"
      @mission_order.pay_mission_order_by_accountant!
    when "paid_by_holding_treasury"
      @mission_order.pay_mission_order_by_holding_treasury!
    end

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

  def set_breadcrumbs
    add_breadcrumb(t("views.layouts.main.requests"))
  end

  def mission_order_params
    params.require(:mission_order).permit(:title, :start_date, :end_date, :indemnity_type, :accommodation, :mission_type, :location, :site_id, :transport_type, :description, :user_id)
  end
end
