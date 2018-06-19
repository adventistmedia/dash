module Dash::TableSorting
  extend ActiveSupport::Concern

  module ClassMethods

    def sort_options(fields, options={})
      options.reverse_merge!(direction: "ASC", profile: :default)
      define_sort_order(options[:profile], options.merge(attributes: sort_fields_to_hash(fields)))
    end

    def sort_fields_to_hash(fields)
      fields.map do |field|
        field.is_a?(Hash) ? field : {field => field.to_s}
      end.reduce({}, :merge).stringify_keys
    end

    def define_sort_order(profile, options)
      method_name = "sort_order"
      method_name = "#{profile}_#{method_name}" if profile != :default
      define_method(method_name) do
        default_column = options[:attributes].keys.first
        column = options[:attributes].keys.include?(params[:col]) ? params[:col] : default_column
        direction = ["ASC", "DESC"].detect{|d| params[:dir] == d } || options[:direction]
        attribute = options[:attributes][column]
        # set
        params[:col] = column
        params[:dir] = direction
        "#{attribute} #{direction}"
      end
      helper_method method_name
    end

  end

end