class CspController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    report = JSON.parse(request.body.read)['csp-report'] rescue {}
    report_formatted = report.collect{|k,v| "#{k}: #{v}"}.join("\n")

    logger.debug report_formatted
    Slacker.post_message report_formatted

    head :ok
  end
end