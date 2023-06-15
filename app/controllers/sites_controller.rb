class SitesController < ApplicationController
  before_action :set_site, only: %i[edit update destroy]
  before_action :set_breadcrumbs, only: %i[index new edit]

  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
  end

  def edit
  end

  def create
    @site = Site.new(site_params)

    if @site.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("site-list", @site),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @site.update(site_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@site, @site),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @site.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    redirect_to sites_path
  end

  private

  def set_site
    @site = Site.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.sites.title_sites"), sites_path)
  end

  def site_params
    params.require(:site).permit(:name, :code, :address, :phone)
  end
end
