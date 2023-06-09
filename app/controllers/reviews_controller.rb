class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]

  def index
    @reviews = Review.all
  end

  def show
  end

  def new
    @review = Review.new
  end

  def edit
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      redirect_to review_path(@review), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      redirect_to review_path(@review), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@review),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(
      :name,
      :start_date,
      :end_date,
      :start_date,
      :review_type,
      user_ids: [],
      sections_attributes: [
        :id,
        :name,
        :description,
        :section_type,
        :_destroy,
        questions_attributes: [
          :id,
          :name,
          :question_type,
          :_destroy,
          options_attributes: [
            :id,
            :name,
            :_destroy
          ]
        ]
      ]
    )
  end
end
