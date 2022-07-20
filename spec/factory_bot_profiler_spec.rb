# frozen_string_literal: true

require "active_support/isolated_execution_state"
require "factory_bot"

RSpec.describe FactoryBotProfiler do
  it "reports factory usage" do
    define_class("FakeRecord") do
      def save!
      end
    end

    define_class("Repository", FakeRecord) do
      attr_accessor :user, :organization

      def initialize
        sleep 0.2
      end
    end

    define_class("User", FakeRecord) do
      attr_accessor :profile

      def initialize
        sleep 0.3
      end
    end

    define_class("Organization", FakeRecord) do
      attr_accessor :owner

      def initialize
        sleep 0.4
      end
    end

    define_class("Profile", FakeRecord) do
      def initialize
        sleep 0.1
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

    FactoryBot.create(:repository) #   1 repo, 1 org, 2 users, 2 profiles
    FactoryBot.create(:organization) #         1 org, 1 user,  1 profile
    FactoryBot.create(:profile) #                              1 profile

    FactoryBotProfiler.report if ENV["DEBUG"]
    collector = test_report

    expect(collector.total_time.round(1)).to eq(2.3)

    highest_count = collector.highest_count(1).first
    expect(highest_count.name).to eq(:profile)
    expect(highest_count.count).to eq(4)

    highest_total_time = collector.highest_total_time(1).first
    expect(highest_total_time.name).to eq(:organization)
    expect(highest_total_time.total_time.round(1)).to eq(1.6)

    highest_self_time = collector.highest_self_time(1).first
    expect(highest_self_time.name).to eq(:user)
    expect(highest_self_time.total_self_time.round(1)).to eq(0.9)

    highest_average_time = collector.highest_average_time(1).first
    expect(highest_average_time.name).to eq(:repository)
    expect(highest_average_time.average_time.round(1)).to eq(1.4)
  end

  private

  def define_class(name, parent = Object, &block)
    stub_const(name, Class.new(parent)).tap do |const|
      const.class_eval(&block) if block
    end
  end

  def test_report
    collector = nil

    reporter = Class.new do
      def initialize(collector)
        @collector = collector
      end

      # Use define_method for the block closure so we can set collector
      define_method :report do
        collector = @collector
      end
    end

    FactoryBotProfiler.report(reporter)

    collector
  end
end
