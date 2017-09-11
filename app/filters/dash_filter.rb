class DashFilter
  class_attribute :filter_options
  attr_accessor :scope, :filters

  # scope = @users
  # filters = {status: 'published', account: 'active'}
  def initialize(scope, filters)
    @scope = scope
    @filters = filters || {}
    clean_filters
  end

  def to_query
    self.filters.each do |name, value|
      if filter = self.filter_options[name][:fields].detect{|f| f[:value] == value} rescue nil
        self.scope = self.scope.where(filter[:condition])
      end
    end
    self.scope
  end

  def any?
    self.filters.any?
  end

  def active_field(filter)
    if value = self.filters[filter]
      self.filter_options[filter][:fields].detect{|f| f[:value] == value }
    end
  end

  def field_active?(filter, field_value)
    self.filters[filter] == field_value
  end

  def self.add_filter(name, options)
    self.filter_options ||= {}
    fields = []
    filter_fields = options[:fields].is_a?(Symbol) ? send(options[:fields]) : options[:fields]
    filter_fields.each do |field|
      fields << if field.is_a?(Array)
        {title: field[0], value: field[1], condition: field[2]}
      else
        column_name = options[:column] || name
        {title: field.titleize, value: field, condition: {options[:table_name] => {column_name => field}} }
      end
    end

    self.filter_options[name] = {title: name.to_s.titleize, label: name, fields: fields}
  end

  private

  # clean up the filters so only valid ones exist
  def clean_filters
    cleaned_filters = {}
    self.filters.each do |name, value|
      if (self.filter_options[name.to_sym][:fields].detect{|f| f[:value] == value } rescue false)
        cleaned_filters[name.to_sym] = value
      end
    end
    self.filters = cleaned_filters
  end

end