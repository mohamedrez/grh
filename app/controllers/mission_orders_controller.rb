class MissionOrdersController < ApplicationController
  before_action :set_user, except: :destroy
  before_action :set_mission_order, only: %i[show edit update destroy]
  before_action :set_breadcrumbs, only: :index

  def index
    ids = UserRequest.where(user_id: @user.id, requestable_type: "MissionOrder").pluck(:requestable_id)
    @mission_orders = MissionOrder.where(id: ids)
  end

  def show
    @user_request = @mission_order.user_request
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

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_mission_order
    @mission_order = MissionOrder.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(@user.full_name, @user)
    add_breadcrumb(t("views.mission_orders.title_mission_orders"), user_mission_orders_path(@user))
  end

  def mission_order_params
    params.require(:mission_order).permit(:title, :start_date, :end_date, :indemnity_type, :accommodation, :mission_type, :location, :site_id, :transport_means, :description)
  end
end
