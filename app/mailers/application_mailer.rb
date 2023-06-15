# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@uat.humaneo.ma"
  layout "mailer"
end
