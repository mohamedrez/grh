class CalendarController < ApplicationController
  def index
    @from_calendar = params[:from_calendar]
  end
end
