require "dash/engine"

require "kaminari"
require "bootstrap/engine"
require "popper_js"
require "simple_form"
require "mandrill_dm"
require "cancancan"
require "audited"
module Dash
  mattr_accessor :user_class
  @@user_class = "User"

  # Configuration
  # Dash.setup do |config|
  #   config.user_class = "User"
  # end
  def self.setup
    yield self
  end
end