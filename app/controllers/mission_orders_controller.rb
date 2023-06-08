class MissionOrdersController < ApplicationController
  before_action :set_mission_order, only: %i[show edit update destroy]

  def index
    @mission_orders = MissionOrder.all
  end

  def show
  end

  def new
    @mission_order = MissionOrder.new
  end

  def edit
  end

  def create
    @mission_order = MissionOrder.new(mission_order_params)

    if @mission_order.save
      redirect_to mission_order_url(@mission_order), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @mission_order.update(mission_order_params)
      redirect_to mission_order_url(@mission_order), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mission_order.destroy

    redirect_to mission_orders_url, notice: t("flash.successfully_destroyed")
  end

  private

  def set_mission_order
    @mission_order = MissionOrder.find(params[:id])
  end

  def mission_order_params
    params.require(:mission_order).permit(:title, :start_date, :end_date, :indemnity_type, :accommodation, :mission_type, :location, :site_id, :transport_means, :description, :rich_text)
  end
end
