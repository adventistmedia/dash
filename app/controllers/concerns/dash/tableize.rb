module Dash::Tableize
  extend ActiveSupport::Concern

  included do
    before_action :about_modal_path, only: [:about]
  end

  # GET
  def about
    @about_object = instance_variable_get("@#{controller_name.singularize}")
    render file: '/dash/base/about'
  end

  private

  def about_modal_path
    @about_modal_path = '/dash/base/about_modal'
  end
end