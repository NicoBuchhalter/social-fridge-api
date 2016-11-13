class NotificateUser < CustomInteractor
  def call
    # notify_by_email
    notify_by_push
    store_notification
  end

  private

  # def notify_by_email
  #   NotificationMailer.delay.simple_notification_email(context.user.id, context.n_type, params)
  # end

  def notify_by_push
    PushNotification.new(user: context.user,
                         message: I18n.t("push_notification.#{context.n_type}"),
                         data: { from_id: context.user_from.id})
                    .simple_notification
  end

  def store_notification
    Notification.create(from: params[:from], to: context.user, n_type: context.n_type,
                        number: params[:number], specific_date: params[:date])
  end

  def params
    { number: context.number, date: context.date, from: context.user_from }
  end
end
