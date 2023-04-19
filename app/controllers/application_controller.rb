# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :pundishing_user

  before_action :set_locale, :set_user

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # TODO: why do we have this one
  def set_user
    cookies[:username] = current_user&.email || "guest"
  end

  def default_url_options(options = {})
    {locale: I18n.locale}.merge options
  end

  def pundishing_user
    flash[:notice] = t("flash.application_controller.not_authorized")
    redirect_to dashboard_path
  end
end
