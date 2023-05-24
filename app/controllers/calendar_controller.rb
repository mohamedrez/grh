class CalendarController < ApplicationController
  def index
    @from_calendar = true? params[:from_calendar]
  end

  private

  def true?(obj)
    obj.to_s.downcase == "true"
  end
end
