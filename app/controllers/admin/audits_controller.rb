class Admin::AuditsController < Admin::BaseController
  before_action :find_audit
  authorize_resource

  def show
  end

  private

  def find_audit
    @audit = Audited::Audit.find(params[:id])
  end

end