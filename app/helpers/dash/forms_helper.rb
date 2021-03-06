module Dash::FormsHelper

  # options sort: true
  def enum_collection(f, column, options={})
    options.reverse_merge!(sort: false)
    keys = f.object.class.send(column).keys
    keys.sort! if options[:sort]
    keys.collect{|c| [f.object.class.base_class.human_attribute_name("#{column.to_s.singularize}.#{c}"), c] }
  end

  def data_for_field(f, association, options={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |fc|
      render(association.to_s.singularize + "_fields", fc: fc)
    end
    fields.gsub("\n", "")
  end

end