require 'csv'
class DashExporter
  class_attribute :exportable
  attr_reader :scope
  attr_accessor :object

  def initialize(scope)
    @scope = scope
  end

  def self.attributes(*export_attributes)
    self.exportable = export_attributes.inject({}) do |hash, attr|
      k, v = attr.is_a?(Array) ? attr : [attr, attr.to_s.titleize]
      hash[k] = v
      hash
    end
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << self.class.exportable.values
      scope.all.each do |item|
        csv << self.class.exportable.keys.map do |attr|
          if respond_to?(attr)
            self.object = item
            self.send(attr)
          else
            item.send(attr)
          end
        end
      end
    end
  end

end