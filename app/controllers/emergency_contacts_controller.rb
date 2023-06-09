class EmergencyContactsController < ApplicationController
  before_action :set_user, only: %i[index new edit create update]
  before_action :set_emergency_contact, only: %i[edit update destroy]
  before_action :set_breadcrumbs, only: :index

  def index
    @emergency_contacts = EmergencyContact.where(user_id: @user.id)
  end

  def new
    @emergency_contact = EmergencyContact.new
  end

  def edit
  end

  def create
    @emergency_contact = EmergencyContact.new(emergency_contact_params)
    @emergency_contact.user_id = @user.id

    if @emergency_contact.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("emergency-contact-list", @emergency_contact),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    emergency_contact_params[:user_id] = params[:user_id]
    if @emergency_contact.update(emergency_contact_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@emergency_contact, @emergency_contact),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @emergency_contact.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@emergency_contact),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_emergency_contact
    @emergency_contact = EmergencyContact.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(@user.full_name, @user)
    add_breadcrumb(t("views.emergency_contacts.title_emergency_contact"), user_emergency_contacts_path(@user))
  end

  def emergency_contact_params
    params.require(:emergency_contact).permit(:name, :relationship, :phone, :email)
  end
end
