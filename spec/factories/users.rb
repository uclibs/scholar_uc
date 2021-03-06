# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    first_name 'Sample'
    last_name 'User'

    factory :user_with_mail do
      after(:create) do |user|
        # Create examples of single file successes and failures
        (1..10).each do |number|
          file = MockFile.new(number.to_s, "Single File #{number}")
          User.batch_user.send_message(user, 'File 1 could not be updated. You do not have sufficient privileges to edit it.', file.to_s, false)
          User.batch_user.send_message(user, 'File 1 has been saved', file.to_s, false)
        end

        # Create examples of mulitple file successes and failures
        files = []
        (1..50).each do |number|
          files << MockFile.new(number.to_s, "File #{number}")
        end
        User.batch_user.send_message(user, 'These files could not be updated. You do not have sufficient privileges to edit them.', 'Batch upload permission denied', false)
        User.batch_user.send_message(user, 'These files have been saved', 'Batch upload complete', false)
      end
    end
  end

  factory :shibboleth_user, class: 'User' do
    ignore do
      count 1
      person_pid nil
    end
    email 'sixplus2@test.com'
    first_name 'Fake'
    last_name 'User'
    password '12345678'
    password_confirmation '12345678'
    sign_in_count { count.to_s }
    provider 'shibboleth'
    uid 'sixplus2@test.com'
  end
end

class MockFile
  attr_accessor :to_s, :id
  def initialize(id, string)
    self.id = id
    self.to_s = string
  end
end
