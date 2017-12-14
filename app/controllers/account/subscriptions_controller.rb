class Account::SubscriptionsController < Account::BaseController
  before_action :find_subscription_notification, only: [:subscribe, :unsubscribe]
  sort_options [:name]
  authorize_resource

  def index
    @subscription_notifications = SubscriptionNotification.order(sort_order)
    @subscription_ids = @current_user.subscriptions.pluck(:subscription_notification_id)
  end

  # POST
  def subscribe
    Subscription.subscribe(@current_user, @subscription_notification, subscribed_by: @current_user)
  end

  # POST
  def unsubscribe
    Subscription.unsubscribe(@current_user, @subscription_notification)
  end

  private

  def find_subscription_notification
    @subscription_notification = SubscriptionNotification.find(params[:subscription_notification_id])
  end

end