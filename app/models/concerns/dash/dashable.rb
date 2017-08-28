module Dash::Dashable
  extend ActiveSupport::Concern

  included do
    class_attribute :applied_filter
  end

  module ClassMethods

    def to_csv
      exporter ||= "#{self.name}Exporter".constantize
      exporter.new(self).to_csv
    end

    def filter(filter_params, options={})
      # set the filter class
      filter_class = options[:filter]
      filter_class ||= "#{self.name}Filter".constantize

      # set the applied filter to the scope for use in views
      self.applied_filter = filter_class.new(self, filter_params)

      # no need to query if params empty
      return all if filter_params.nil?

      # initialize and add conditions to scope
      self.applied_filter.to_query
    end

  end

end