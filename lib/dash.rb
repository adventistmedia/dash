require "dash/version"

module Dash
  class << self
    # Inspired by Kaminari
    def load!

      register_rails_engine

      configure_sass
    end

    # Paths
    def gem_path
      @gem_path ||= File.expand_path '..', File.dirname(__FILE__)
    end

    def stylesheets_path
      File.join assets_path, 'stylesheets'
    end

    def javascripts_path
      File.join assets_path, 'javascripts'
    end

    def assets_path
      @assets_path ||= File.join gem_path, 'assets'
    end

    private

    def configure_sass
      require 'sass'

      ::Sass.load_paths << stylesheets_path
    end

    def register_rails_engine
      require 'dash/engine'
      require 'bootstrap/engine'
      require 'popper_js'
    end

  end
end

Dash.load!