class RolesController < ApplicationController
  before_action :set_role, only: %i[edit update destroy]
  before_action :set_breadcrumbs, only: :index
  before_action :set_authorization

  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("role-list", @role),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@role, @role),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@role),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def set_authorization
    authorize!
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.role.the_role"), roles_path)
  end

  def role_params
    params.require(:role).permit(:name, :user_id)
  end
end
