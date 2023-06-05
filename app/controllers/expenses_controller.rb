class ExpensesController < ApplicationController
  before_action :set_user
  before_action :set_expense, only: %i[show edit update destroy update_status delete_receipt]
  before_action :set_breadcrumbs

  def index
    @expenses = Expense.where(user_id: @user.id)
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def edit
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = @user.id

    if @expense.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("expense-list", @expense),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    expense_params[:user_id] = params[:user_id]
    if @expense.update(expense_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@expense, @expense),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@expense),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  def update_status
    status = params[:status]
    @expense.update!(status: status)
    redirect_to user_expense_path(@user, @expense), notice: t("flash.status_successfully_updated")
  end

  def delete_receipt
    receipt = ActiveStorage::Attachment.find(params[:receipt_id])
    receipt.destroy
    redirect_to user_expense_path(@user, @expense), notice: t("flash.receipt_successfully_deleted")
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.expenses.title_expenses"), user_expenses_path(@user))
  end

  def expense_params
    params.require(:expense).permit(:date, :category, :description, :amount, receipts: [])
  end
end
