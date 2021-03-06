# frozen_string_literal: true

# Please do not make direct changes to this file!
# This generator is maintained by the community around simple_form-bootstrap:
# https://github.com/rafaelfranca/simple_form-bootstrap
# All future development, tests, and organization should happen there.
# Background history: https://github.com/plataformatec/simple_form/issues/1561

# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/plataformatec/simple_form#custom-components
# to know more about custom components.
# Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  # Default class for buttons
  config.button_class = 'btn'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'form-check-label'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert alert-danger'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # add validation classes to `input_field`
  config.input_field_error_class = 'is-invalid'
  config.input_field_valid_class = 'is-valid'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  config.wrapper_mappings = {
    boolean:       :vertical_boolean,
    check_boxes:   :vertical_collection,
    radio_buttons: :vertical_collection
  }

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'form-control-label'
    b.use :input, class: 'form-control', error_class: 'is-invalid', valid_class: 'is-valid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  # vertical input for boolean
  config.wrappers :vertical_boolean, tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, tag: 'div', class: 'form-check' do |bb|
      bb.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
      bb.use :label, class: 'form-check-label'
      bb.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
      bb.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  # vertical input for radio buttons and check boxes
  config.wrappers :vertical_collection, item_wrapper_class: 'form-check', tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  # config.wrapper_mappings = {
  #   boolean:       :vertical_boolean,
  #   check_boxes:   :vertical_collection,
  #   date:          :vertical_multi_select,
  #   datetime:      :vertical_multi_select,
  #   file:          :vertical_file,
  #   radio_buttons: :vertical_collection,
  #   range:         :vertical_range,
  #   time:          :vertical_multi_select
  # }








  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.
  # config.wrappers :default, :class => :input,
  #   :error_class => :field_with_errors, :hint_class => :field_with_hint  do |b|
  #   ## Extensions enabled by default
  #   # Any of these extensions can be disabled for a
  #   # given input by passing: `f.input EXTENSION_NAME => false`.
  #   # You can make any of these extensions optional by
  #   # renaming `b.use` to `b.optional`.
  #
  #   # Determines whether to use HTML5 (:email, :url, ...)
  #   # and required attributes
  #   b.use :html5
  #
  #   # Calculates placeholders automatically from I18n
  #   # You can also pass a string as f.input :placeholder => "Placeholder"
  #   b.use :placeholder
  #
  #   ## Optional extensions
  #   # They are disabled unless you pass `f.input EXTENSION_NAME => :lookup`
  #   # to the input. If so, they will retrieve the values from the model
  #   # if any exists. If you want to enable the lookup for any of those
  #   # extensions by default, you can change `b.optional` to `b.use`.
  #
  #   # Calculates maxlength from length validations for string inputs
  #   b.optional :maxlength
  #
  #   # Calculates pattern from format validations for string inputs
  #   b.optional :pattern
  #
  #   # Calculates min and max from length validations for numeric inputs
  #   b.optional :min_max
  #
  #   # Calculates readonly automatically from readonly attributes
  #   b.optional :readonly
  #
  #   ## Inputs
  #   b.use :label_input
  #   b.use :error, :wrap_with => { :tag => :span, :class => :error }
  #   b.use :hint,  :wrap_with => { :tag => :span, :class => :hint }
  # end
  #
  # # The default wrapper to be used by the FormBuilder.
  # config.default_wrapper = :default
  #
  # # Define the way to render check boxes / radio buttons with labels.
  # # Defaults to :nested for bootstrap config.
  # #   :inline => input + label
  # #   :nested => label > input
  # config.boolean_style = :inline
  #
  # # Default class for buttons
  # config.button_class = 'btn btn-secondary'
  #
  # # Method used to tidy up errors. Specify any Rails Array method.
  # # :first lists the first message for each field.
  # # Use :to_sentence to list all errors for each field.
  # # config.error_method = :first
  #
  # # Default tag used for error notification helper.
  # config.error_notification_tag = :div
  #
  # # CSS class to add for error notification helper.
  # config.error_notification_class = 'alert alert-danger'
  #
  # # ID to add for error notification helper.
  # # config.error_notification_id = nil
  #
  # # Series of attempts to detect a default label method for collection.
  # # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]
  #
  # # Series of attempts to detect a default value method for collection.
  # # config.collection_value_methods = [ :id, :to_s ]
  #
  # # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # # config.collection_wrapper_tag = nil
  #
  # # You can define the class to use on all collection wrappers. Defaulting to none.
  # # config.collection_wrapper_class = nil
  #
  # # You can wrap each item in a collection of radio/check boxes with a tag,
  # # defaulting to :span. Please note that when using :boolean_style = :nested,
  # # SimpleForm will force this option to be a label.
  # # config.item_wrapper_tag = :span
  #
  # # You can define a class to use in all item wrappers. Defaulting to none.
  # # config.item_wrapper_class = nil
  #
  # # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }
  #
  # # You can define the class to use on all labels. Default is nil.
  # config.label_class = 'control-label'
  #
  # # You can define the class to use on all forms. Default is simple_form.
  # # config.form_class = :simple_form
  #
  # # You can define which elements should obtain additional classes
  # # config.generate_additional_classes_for = [:wrapper, :label, :input]
  #
  # # Whether attributes are required by default (or not). Default is true.
  # # config.required_by_default = true
  #
  # # Tell browsers whether to use default HTML5 validations (novalidate option).
  # # Default is enabled.
  # config.browser_validations = false
  #
  # # Collection of methods to detect if a file type was given.
  # # config.file_methods = [ :mounted_as, :file?, :public_filename ]
  #
  # # Custom mappings for input types. This should be a hash containing a regexp
  # # to match as key, and the input type that will be used when the field name
  # # matches the regexp as value.
  # # config.input_mappings = { /count/ => :integer }
  #
  # # Custom wrappers for input types. This should be a hash containing an input
  # # type as key and the wrapper that will be used for all inputs with specified type.
  # # config.wrapper_mappings = { :string => :prepend }
  #
  # # Default priority for time_zone inputs.
  # # config.time_zone_priority = nil
  #
  # # Default priority for country inputs.
  # # config.country_priority = nil
  #
  # # Default size for text inputs.
  # # config.default_input_size = 50
  #
  # # When false, do not use translations for labels.
  # # config.translate_labels = true
  #
  # # Automatically discover new inputs in Rails' autoload path.
  # # config.inputs_discovery = true
  #
  # # Cache SimpleForm inputs discovery
  # # config.cache_discovery = !Rails.env.development?
  #
  # # Default class for inputs
  # # config.input_class = 'form-control'
end