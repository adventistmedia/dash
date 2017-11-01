module Dash::LayoutHelper

  def favicon_links
    tag(:link, rel: "icon", type: "image/png", sizes: "16x16", href: asset_url("/favicon-16x16.png")) +
    tag(:link, rel: "icon", type: "image/png", sizes: "32x32", href: asset_url("/favicon-32x32.png")) +
    tag(:link, rel: "apple-touch-icon", type: "image/png", sizes: "180x180", href: asset_url("/apple-touch-icon.png"))
  end

  def meta_links
    tag(:meta, charset: "utf-8") +
    tag(:meta, content: "IE=edge", "http-equiv" => "X-UA-Compatible") +
    tag(:meta, name: "viewpoint", content: "width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, shrink-to-fit=no, user-scalable=no")
  end

  def meta_and_favicon_links
    meta_links + favicon_links
  end
end