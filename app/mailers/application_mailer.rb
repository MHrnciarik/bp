class ApplicationMailer < ActionMailer::Base
  default from: -> { Rails.configuration.x.mailer_from.presence || "from@example.com" }
  layout "mailer"
end
