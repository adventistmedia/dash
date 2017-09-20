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
      label: "Image",
      required: false,
      file_type: "image",
      path: path,
      attribute: :asset_id,
      callback: "assetInsertCallback"
    )
    asset_selector(f, options)
  end

  # default asset selector settings
  def asset_selector(f, options={})
    asset = f.object.send(options[:attribute].to_s.gsub(/_id$/, ""))
    id = "#{options[:attribute].to_s.tr("_","-")}-#{f.object.object_id}"
    errors = f.object.errors[options[:attribute].to_sym]
    preview = ""

    preview = image_tag(asset.media.thumb.url.to_s) if asset.present?

    div_class = "file-asset form-group select"
    div_class += " required" if options[:required]
    div_class += " has-error" if errors.any?
    label = options[:label]

    content_tag(:div, id: id, class: div_class) do
      f.hidden_field(options[:attribute], class: "file-value") +
      content_tag(:div, f.label(options[:attribute], label: label, class: "control-label", required: options[:required])) +
      content_tag(:span, preview, class: "file-preview file-preview-#{options[:file_type]}") +
      link_to(content_tag(:span,"", class: "fa fa-plus"), options[:path], class: "file-btn-add btn btn-secondary btn-xs lightbox-iframe", data: {uniq_id: id, callback: options[:callback]}) +
      link_to(content_tag(:span,"", class: "fa fa-times"), "#", class: "file-btn-remove btn btn-secondary btn-xs remove") +
      (errors.any? ? content_tag(:span, errors.first, class: "error-block help-block") : nil) +
      (options.key?(:hint) ? content_tag(:p, options[:hint], class: "help-block") : nil)
    end
  end
end