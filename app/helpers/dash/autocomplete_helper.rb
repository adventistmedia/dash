module Dash::AutocompleteHelper

  def autocomplete(options={})
    id = "ia-#{rand(99999999)}"
    content_tag(:div, class: "input string ia-wrapper") do
      content_tag(:label, options[:label], class: "control-label") +
      text_field_tag(:search, options[:value], placeholder: options[:placeholder], data: {url: options[:url], target: options[:target]}, id: id, autocomplete: "off", class: "form-control input-autocomplete") +
      content_tag(:ul, "", id: "#{id}-results", class: "ia-results")
    end
  end
end