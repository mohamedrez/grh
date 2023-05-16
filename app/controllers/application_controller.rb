# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale, :set_user
  before_action :authenticate_user!

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

  def default_url_options(options = {})
    {locale: I18n.locale}.merge options
  end

  def set_user
    cookies[:username] = current_user&.email || "guest"
  end
end
