class TimeOffRequestsController < ApplicationController
  before_action :set_time_off_request, only: %i[show edit update destroy]

  # GET /time_off_requests or /time_off_requests.json
  def index
    @time_off_requests = TimeOffRequest.all
  end

  # GET /time_off_requests/1 or /time_off_requests/1.json
  def show
  end

  # GET /time_off_requests/new
  def new
    @time_off_request = TimeOffRequest.new
    @user_id = params[:user_id]
  end

  # GET /time_off_requests/1/edit
  def edit
  end

  # POST /time_off_requests or /time_off_requests.json
  def create
    @time_off_request = TimeOffRequest.new(time_off_request_params.except(:user_id))
    respond_to do |format|
      @time_off_request.user_id = time_off_request_params[:user_id]
      if @time_off_request.save
        format.html { redirect_to time_off_request_url(@time_off_request), notice: "Time off request was successfully created." }
        format.json { render :show, status: :created, location: @time_off_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_off_requests/1 or /time_off_requests/1.json
  def update
    respond_to do |format|
      if @time_off_request.update(time_off_request_params)
        format.html { redirect_to time_off_request_url(@time_off_request), notice: "Time off request was successfully updated." }
        format.json { render :show, status: :ok, location: @time_off_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_off_requests/1 or /time_off_requests/1.json
  def destroy
    @time_off_request.destroy

    respond_to do |format|
      format.html { redirect_to time_off_requests_url, notice: "Time off request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_off_request
    @time_off_request = TimeOffRequest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def time_off_request_params
    params.require(:time_off_request).permit(:content, :start_date, :end_date, :user_id)
  end
end
