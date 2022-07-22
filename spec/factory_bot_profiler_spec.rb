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

    stats = FactoryBotProfiler::AggregateStats.new
    FactoryBotProfiler.subscribe(stats)

    FactoryBot.create(:repository) #   1 repo, 1 org, 2 users, 2 profiles
    FactoryBot.create(:organization) #         1 org, 1 user,  1 profile
    FactoryBot.create(:profile) #                              1 profile

    FactoryBotProfiler.report if ENV["DEBUG"]

    expect(stats.total_time.round(1)).to eq(2.3)

    highest_count = stats.highest_count(1).first
    expect(highest_count.name).to eq(:profile)
    expect(highest_count.count).to eq(4)

    highest_total_time = stats.highest_total_time(1).first
    expect(highest_total_time.name).to eq(:organization)
    expect(highest_total_time.total_time.round(1)).to eq(1.6)

    highest_self_time = stats.highest_self_time(1).first
    expect(highest_self_time.name).to eq(:user)
    expect(highest_self_time.total_self_time.round(1)).to eq(0.9)

    highest_average_time = stats.highest_average_time(1).first
    expect(highest_average_time.name).to eq(:repository)
    expect(highest_average_time.average_time.round(1)).to eq(1.4)
  end

  it "reports with traits" do
    define_class("FakeRecord") do
      def save!
      end
    end

    define_class("Car", FakeRecord) do
      attr_accessor :moon_roof, :flatscreen_tv, :seat_warmer

      def initialize
        sleep 0.4
      end
    end

    define_class("MoonRoof", FakeRecord) do
      def initialize
        sleep 0.3
      end
    end

    define_class("FlatscreenTv", FakeRecord) do
      def initialize
        sleep 0.2
      end
    end

    define_class("SeatWarmer", FakeRecord) do
      def initialize
        sleep 0.1
      end
    end

    FactoryBot.define do
      factory :car do
        trait(:lx) do
          association :moon_roof
          association :flatscreen_tv
          association :seat_warmer
        end

        trait(:ex) do
          association :moon_roof
        end
      end

      factory :moon_roof
      factory :flatscreen_tv
      factory :seat_warmer
    end

    stats = FactoryBotProfiler::AggregateStats.new
    FactoryBotProfiler.subscribe(stats)

    FactoryBot.create(:car)
    FactoryBot.create(:car, :ex)
    FactoryBot.create(:car, :lx)

    FactoryBotProfiler.report if ENV["DEBUG"]

    expect(stats.total_time.round(1)).to eq(2.1)

    highest_total_time = stats.highest_total_time(1).first
    expect(highest_total_time.name).to eq(:car)

    expect(highest_total_time.child_times[:moon_roof].round(1)).to eq(0.6)
    expect(highest_total_time.child_times[:flatscreen_tv].round(1)).to eq(0.2)
    expect(highest_total_time.child_times[:seat_warmer].round(1)).to eq(0.1)

    expect(highest_total_time.child_counts[:moon_roof]).to eq(2)
    expect(highest_total_time.child_counts[:flatscreen_tv]).to eq(1)
    expect(highest_total_time.child_counts[:seat_warmer]).to eq(1)
  end

  private

  def define_class(name, parent = Object, &block)
    stub_const(name, Class.new(parent)).tap do |const|
      const.class_eval(&block) if block
    end
  end
end
