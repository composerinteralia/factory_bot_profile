# frozen_string_literal: true

require "active_support/notifications"
require "active_support/isolated_execution_state"
require "factory_bot"

RSpec.describe FactoryBotProfiler do
  it "reports factory usage" do
    class FakeRecord
      def save!
        sleep 0.1
      end
    end

    class Repository < FakeRecord
      attr_accessor :user, :organization

      def initialize
        sleep 0.5
      end
    end

    class User < FakeRecord
      attr_accessor :profile

      def initialize
        sleep 0.2
      end
    end

    class Organization < FakeRecord
      attr_accessor :owner

      def initialize
        sleep 0.3
      end
    end

    class Profile < FakeRecord
      def initialize
        sleep 0.4
      end
    end

    FactoryBot.define do
      factory :repository do
        association :user
        association :organization
      end

      factory :user do
        association :profile
      end

      factory :organization do
        association :owner, factory: :user
      end

      factory :profile
    end

    FactoryBotProfiler.subscribe
    FactoryBot.create(:repository)
    FactoryBotProfiler.report
  end
end
