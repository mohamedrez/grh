class HolidaysController < ApplicationController
  before_action :set_holiday, only: %i[edit update]
  before_action :set_breadcrumbs

  def index
    @holidays = Holiday.order(start_date: :asc)
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params)

    if @holiday.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.prepend("holiday-list", @holiday),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @holiday.update(holiday_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@holiday, @holiday),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.holidays.title_holidays"), holidays_path)
  end

  def holiday_params
    params.require(:holiday).permit(:name, :start_date, :end_date)
  end
end
