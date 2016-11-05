class NotificationMailer < ApplicationMailer
  add_template_helper(ViewHelper)

  def simple_notification_email(user_id, n_type, params)
    @user = User.find_by_id(user_id)
    email_urls
    @email_address = @user.email
    @n_type = n_type
    @body = text(params)
    mail(to: @email_address,
         subject: t("notifications.#{@n_type}.subject"))
  end

  private

  def text(notification_params)
    I18n.t("notifications.#{@n_type}.body", notification_params)
  end
end
