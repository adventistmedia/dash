module Dash::Tableize
  extend ActiveSupport::Concern

  included do
    before_action :about_modal_path, only: [:about]
    before_action :find_selection, only: [:batch_destroy, :batch_update]
  end

  # GET
  ## About card showing audit history if one exists and other basic details
  def about
    @about_object = instance_variable_get("@#{controller_name.singularize}")
    render template: "/dash/base/about"
  end

  # POST
  # delete multiple objects
  def batch_destroy
    @success = @selected.destroy_all
    render template: "/dash/base/batch_destroy"
  end

  # POST
  # edit multiple objects
  def batch_update
    @success = true
    ActiveRecord::Base.transaction do
      @selected.each do |selected|
        unless selected.update(batch_update_params)
          @success = false
          raise ActiveRecord::Rollback
        end
      end
    end
    render template: "/dash/base/batch_update"
  end

  private

  def about_modal_path
    @about_modal_path = "/dash/base/about_modal"
  end

  def find_selection
    @selected = "#{controller_name.singularize.classify}".constantize.where(id: batch_ids)
  end

  def batch_ids
    params[:batch][:ids].to_s.split(",")
  end

  def batch_update_params
    # override
    params[:batch].permit(:last_name)
  end

  def to_csv(scope, options={})
    options.reverse_merge!(filename: "#{scope.table_name}-export-#{Date.today}.csv")
    send_data scope.to_csv, filename: options[:filename]
  end

end
