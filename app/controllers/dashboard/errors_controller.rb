class Dashboard::ErrorsController < ApplicationController

  def page_not_found
    render status: 404, layout: "dash/session"
  end

  # A 500 error uses the dash error layout as the dashboard layout maybe
  # the cause of the 500 error
  def server_error
    messages = ["Captain!", "Man overboard!", "Ekk!"]
    MsteamsNotifier::Message.quick_message "#{messages.sample} We've had a 500 error at #{request.referrer}"
    render status: 500, layout: "dash/error"
  end
end
