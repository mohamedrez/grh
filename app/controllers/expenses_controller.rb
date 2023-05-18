class ExpensesController < ApplicationController
  before_action :set_user
  before_action :set_expense, only: %i[show edit update]

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
      redirect_to expense_url(@expense), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    expense_params[:user_id] = params[:user_id]
    if @expense.update(expense_params)
      redirect_to expense_url(@expense), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:date, :category, :description, :amount, :status)
  end
end
