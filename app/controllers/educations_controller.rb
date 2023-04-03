class EducationsController < ApplicationController
  before_action :set_education, only: %i[ show edit update destroy ]

  # GET /educations or /educations.json
  def index
    @educations = Education.all
  end

  # GET /educations/1 or /educations/1.json
  def show
  end

  # GET /educations/new
  def new
    @education = Education.new
  end

  # GET /educations/1/edit
  def edit
  end

  # POST /educations or /educations.json
  def create
    @education = Education.new(education_params)

    respond_to do |format|
      if @education.save
        format.html { redirect_to edit_user_url(@education.user), notice: "Education was successfully created." }
        format.json { render :show, status: :created, location: @education }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /educations/1 or /educations/1.json
  def update
    respond_to do |format|
      if @education.update(education_params)
        format.html { redirect_to education_url(@education), notice: "Education was successfully updated." }
        format.json { render :show, status: :ok, location: @education }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /educations/1 or /educations/1.json
  def destroy
    @education.destroy

    respond_to do |format|
      format.html { redirect_to educations_url, notice: "Education was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education
      @education = Education.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def education_params
      params.require(:education).permit(:school, :country, :city, :education_level, :study_field, :start_date, :end_date, :still_on_this_course, :user_id)
    end
end
