class EmergencyContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_locals, only: %i[edit update]

  def index
    @user = User.find(params[:user_id])
    @emergency_contacts = EmergencyContact.where(user_id: @user.id)
  end

  def new
    @emergency_contact = EmergencyContact.new
    @user = User.find(params[:user_id])
  end

  def edit
  end

  def create
    @user = User.find(params[:user_id])
    @emergency_contact = EmergencyContact.new(emergency_contact_params)
    @emergency_contact.user_id = @user.id

    if @emergency_contact.save
      redirect_to user_emergency_contacts_url(@user.id), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    emergency_contact_params[:user_id] = params[:user_id]
    if @emergency_contact.update(emergency_contact_params)
      redirect_to user_emergency_contacts_url(params[:user_id]), notice: t("flash.successfully_created")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_locals
    @emergency_contact = EmergencyContact.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def emergency_contact_params
    params.require(:emergency_contact).permit(:name, :relationship, :phone, :email, :user_id)
  end
end
