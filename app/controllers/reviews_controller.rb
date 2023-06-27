class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_breadcrumbs, only: %i[index show new edit]

  def index
    @reviews = Review.all
  end

  def show
    add_breadcrumb(@review.name)
  end

  def new
    @review = Review.new

    section = @review.sections.build
    question = section.questions.build
    question.options.build

    add_breadcrumb(t("views.reviews.add_review"))
  end

  def edit
    add_breadcrumb(@review.name, @review)
    add_breadcrumb(t("views.reviews.edit_review"))
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
    if params[:from] == "index_view"
      render turbo_stream: [
        turbo_stream.remove(@review),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    elsif params[:from] == "show_view"
      redirect_to reviews_path
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.reviews.performance_reviews"), reviews_path)
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
