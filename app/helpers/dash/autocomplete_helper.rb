module Dash::AutocompleteHelper

  def autocomplete(options={})
    id = "ia-#{rand(99999999)}"
    no_results_text = options.key?(:no_results_text) ? j(options[:no_results_text]) : nil
    data = {url: options[:url], target: options[:target], submit: (options[:submit] ? 1 : 0), no_results_text: no_results_text, no_results_callback: options[:no_results_callback]}
    content_tag(:div, class: "input string ia-wrapper #{options[:input_class]}") do
      concat content_tag(:label, options[:label], class: "control-label") if options[:label]
      concat text_field_tag(:search, options[:value], placeholder: options[:placeholder], data: data, id: id, autocomplete: "off", class: "form-control input-autocomplete #{options[:text_class]}")
      concat content_tag(:ul, "", id: "#{id}-results", class: "ia-results")
    end
  end
end