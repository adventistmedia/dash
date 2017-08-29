module Dash::SnackbarHelper

  def snackbar_messages
    html = ""
    [:notice, :alert].each do |level|
      unless flash[level].blank?
        html += content_tag(:div, flash[level], class: "snackbar snackbar-#{snackbar_state(level)}")
      end
    end
    html.html_safe
  end

  def snackbar_state(level)
    case level
    when :notice
      "success"
    when :alert
      "danger"
    else
      "warning"
    end

  end

end