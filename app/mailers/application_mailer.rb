# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@hachimy.com"
  layout "mailer"
end
