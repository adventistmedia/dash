module Dash::ChooserHelper

  # view path for chooser actions
  def chooser_path(action='')
    [@chooser_path, action].reject(&:blank?).join("/")
  end

  # image selector settings
  def image_selector(f, options={})
    namespace = options[:namespace] || "dashboard"
    path = "/" +[namespace, "chooser", "image"].join("/") + "?tabs=images,upload"
    options.reverse_merge!(
      label: t("dash.image_selector.label"),
      file_type: "image",
      path: path,
      attribute: :asset_id,
      callback: "assetInsertCallback"
    )
    asset_selector(f, options)
  end

  def required_input?(f, attribute)
    f.object.class.validators_on(attribute).map(&:class).include?(ActiveRecord::Validations::PresenceValidator)
  end

  # default asset selector settings
  def asset_selector(f, options={})
    options.reverse_merge!(required: required_input?(f, options[:attribute]))
    asset = f.object.send(options[:attribute].to_s.gsub(/_id$/, ""))
    id = "#{options[:attribute].to_s.tr("_","-")}-#{f.object.object_id}"
    errors = f.object.errors[options[:attribute].to_sym]
    preview = ""
    if asset.present? && asset.image?
      preview = image_tag(asset.media.thumb.url.to_s)
    elsif asset.present? && !asset.image?
      preview = asset.name
    end
    div_class = "input string asset-selector"
    div_class += " required" if options[:required]
    div_class += " field_with_errors" if errors.any?
    label = options[:label]

    content_tag(:div, id: id, class: div_class) do
      f.hidden_field(options[:attribute], class: "file-value") +
      content_tag(:div, f.label(options[:attribute], label: label, required: options[:required])) +
      content_tag(:span, preview, class: "file-preview file-preview-#{options[:file_type]}") +
      link_to(content_tag(:span,"", class: "fa fa-plus"), options[:path], class: "btn btn-secondary btn-sm lightbox-iframe", data: {uniq_id: id, callback: options[:callback]}) +
      link_to(content_tag(:span,"", class: "fa fa-times"), "#", class: "file-btn-remove btn btn-secondary btn-sm remove") +
      (errors.any? ? content_tag(:span, errors.first, class: "error") : nil) +
      (options.key?(:hint) ? content_tag(:p, options[:hint], class: "help") : nil)
    end
  end

  def s3_uploader_form(options = {}, &block)
    uploader = S3Uploader.new(site: @site)
    form_tag(uploader.url, s3_form_options(options)) do
      uploader.fields.map do |name, value|
        hidden_field_tag(name, value)
      end.join.html_safe + capture(&block)
    end
  end

  def s3_form_options(options)
    {
      id: "fileupload",
      class: "document-fileupload",
      method: "post",
      authenticity_token: false,
      multipart: true,
      data: {
        as: "file",
        callback_url: options[:callback_url]
      }
    }
  end
end