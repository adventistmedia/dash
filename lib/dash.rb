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

  # Create user account automatically on successfull sign in
  mattr_accessor :create_user_on_signin
  @@create_user_on_signin = true

  # Configuration
  # Dash.setup do |config|
  #   config.user_class = "User"
  # end
  def self.setup
    yield self
  end
end