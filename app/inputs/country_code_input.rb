class CountryCodeInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options)
    label_method, value_method = detect_collection_methods
    collection = Worldly::Country.all.dup #ensure use dup, otherwise overrides Wordly
    if input_options.key?(:countries) && input_options[:countries].any?
      collection.select!{|s| input_options[:countries].include?(s[1]) }
    end
    unless input_options.key?(:include_blank)
      input_options[:include_blank] = false
    end
    if input_html_options.key?(:data)
      input_html_options[:data].reverse_merge!({as: @builder.object_name})
    else
      input_html_options.reverse_merge!({data: {as: @builder.object_name}})
    end
    @builder.collection_select(attribute_name, collection,
      value_method, label_method,
      input_options, input_html_options
    )
  end

end