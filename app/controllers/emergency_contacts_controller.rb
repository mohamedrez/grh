class EmergencyContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_locals, only: %i[edit update destroy]

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
      flash.now[:notice] = "Emergency contact successfully created."
      render turbo_stream: [
        turbo_stream.prepend("emergency_contacts", @emergency_contact),
        turbo_stream.replace("notification_alert", partial: "layouts/alert"),
        turbo_stream.remove("new_emergency_contact")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @emergency_contact.destroy
    flash.now[:notice] = "emergency contact was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@emergency_contact),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end
  def update
    emergency_contact_params[:user_id] = params[:user_id]
    if @emergency_contact.update(emergency_contact_params)
      flash.now[:notice] = "User was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@emergency_contact, @emergency_contact),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
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
