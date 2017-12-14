module Dash::SubscriptionsHelper

  def subscription_toggle(subscription_notification, active = false)
    icon = active ? "fa-toggle-on text-success" : "fa-toggle-off text-danger"
    url = active ? unsubscribe_account_subscriptions_path(subscription_notification_id: subscription_notification.id) : subscribe_account_subscriptions_path(subscription_notification_id: subscription_notification.id)
    link_to(content_tag(:i, "", class: "fa fa-2x #{icon}"), url, method: :post, remote: true)
  end

end