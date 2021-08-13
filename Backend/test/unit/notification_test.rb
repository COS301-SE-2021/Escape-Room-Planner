require 'test_helper'
require './app/Services/notification_services'

class NotificationTest < ActiveSupport::TestCase
  test 'test send email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('kayla.latty.kal@gmail.com')
    resp = ns.send_email_notification(req)

    assert(resp.success)

  end


end
