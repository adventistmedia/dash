require "dash/engine"

require "kaminari"
require "bootstrap/engine"
require "popper_js"
require "simple_form"
require "mandrill_dm"
require "cancancan"
require "audited"
require "record_tag_helper"
require "worldly"
require "faraday"
require "slack-notifier"
require "carrierwave"

module Dash
  mattr_accessor :user_class
  @@user_class = "User"
  mattr_accessor :site_name
  @@site_name = "Adventist Church"

  mattr_accessor :document_upload_max_size
  @@document_upload_max_size = 100.megabytes

  mattr_accessor :image_upload_max_size
  @@image_upload_max_size = 1.megabytes

  # Configuration
  # Dash.setup do |config|
  #   config.user_class = "User"
  # end
  def self.setup
    yield self
  end
end