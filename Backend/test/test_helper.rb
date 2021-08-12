# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1, with: 1)
  BEARER = '"Bearer'
  BASIC = '"Basic'

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def authed_get_call(link)
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    get link,
        headers: { "Authorization1": "#{BEARER} #{res_l.token}\"",
                   "Authorization2": "#{BASIC} testUser" }

    # @response
  end

  def authed_post_call(link, in_params)
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    post link,
         headers: { "Authorization1": "#{BEARER} #{res_l.token}\"",
                    "Authorization2": "#{BASIC} testUser" },
         params: in_params
  end

  def authed_delete_call(link, in_params)
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    delete link,
           headers: { "Authorization1": "#{BEARER} #{res_l.token}\"",
                      "Authorization2": "#{BASIC} testUser" },
           params: in_params

    JSON.parse(@response.body)
  end

  def authed_put_request(link, in_params)
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    put link,
        headers: { "Authorization1": "#{BEARER} #{res_l.token}\"",
                   "Authorization2": "#{BASIC} testUser" },
        params: in_params, as: :as_json

    JSON.parse(@response.body)
  end
  # Add more helper methods to be used by all tests here...
end
