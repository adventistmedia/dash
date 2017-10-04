class PickDatetimeInput < SimpleForm::Inputs::StringInput

  def input(wrapper_options)
    value = input_html_options[:value]
    value ||= object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= value.strftime('%Y/%m/%d %I:%M %p') if value.present?
    input_html_classes << "datetimepicker"

    super # leave StringInput to do the real rendering
  end

end