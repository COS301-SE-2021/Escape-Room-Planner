require 'test_helper'
require './app/Services/notification_services'

class NotificationTest < ActiveSupport::TestCase
  test 'test send verify account email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('verifyAccount','test@gmail.com')
    resp = ns.send_email_notification(req)

    assert(resp.success)

  end

  test 'test send reset password email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('resetPassword','test@gmail.com')
    resp = ns.send_email_notification(req)

    assert(resp.success)

  end

  test 'test send test email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('testEmail','test@gmail.com')
    resp = ns.send_email_notification(req)

    assert(resp.success)

  end

  test 'test send invalid type email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('rando','test@gmail.com')
    resp = ns.send_email_notification(req)

    assert_equal(false, resp.success)

  end

  test 'test null request send email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new(nil,nil)
    resp = ns.send_email_notification(req)

    assert_equal(false, resp.success)

  end

  test 'test null mailer email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new(nil,'test@gmail.com')
    resp = ns.send_email_notification(req)

    assert_equal(false, resp.success)

  end

  test 'test invalid email' do
    ns = NotificationServices.new
    req = SendEmailNotificationRequest.new('verifyAccount','test2@gmail.com')
    resp = ns.send_email_notification(req)

    assert_equal(false, resp.success)
  end


end
