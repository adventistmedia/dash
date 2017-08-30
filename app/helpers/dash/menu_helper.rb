module Dash::MenuHelper

  # Link for main menu. Pass a block for submenu links
  # menu_link('Overview', dashboard_path, icon: 'dashboard')
  def menu_link(key, title, url, options={}, &block)
    options.reverse_merge!(submenus: [], html: {})
    content_tag(:li, class: "#{'active' if options[:submenus].include?(@nav_active)}") do
      concat menu_icon_link(key, title, url, options)
      concat content_tag(:ul, capture(&block), class: "nav-subgroup") if block_given?
    end
  end

  def menu_icon_link(key, title, url, options)
    options[:html][:class] = "nav-group-item #{'expandable' if options[:submenus].any?} #{'active' if key == @nav_active}"
    link_to(url, options[:html]) do
      concat(content_tag(:i, "", class: "icon fa fa-#{options[:icon]}").html_safe + title)
      concat content_tag(:i, '', class: 'fa fa-angle-down expand') if options[:submenus].any?
    end
  end

  # submenu link
  def submenu_link(key, title, url)
    content_tag(:li, link_to(content_tag(:span, title), url, class: "nav-subgroup-item #{'active' if key == @nav_active}"))
  end
end