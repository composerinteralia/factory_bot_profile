# frozen_string_literal: true

require "active_support/isolated_execution_state"
require "factory_bot"
require "fileutils"

RSpec.describe FactoryBotProfile do
  it "reports factory usage" do
    define_class("Repository") do
      attr_accessor :user, :organization

      def save!
        Timecop.travel(Time.now + 2)
      end
    end

    define_class("User") do
      attr_accessor :profile

      def save!
        Timecop.travel(Time.now + 3)
      end
    end

    define_class("Organization") do
      attr_accessor :owner

      def save!
        Timecop.travel(Time.now + 4)
      end
    end

    define_class("Profile") do
      def save!
        Timecop.travel(Time.now + 1)
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

    subscription = FactoryBotProfile.subscribe

    FactoryBot.create(:repository) #   1 repo, 1 org, 2 users, 2 profiles
    FactoryBot.create(:organization) #         1 org, 1 user,  1 profile
    FactoryBot.create(:profile) #                              1 profile

    subscription.unsubscribe
    stats = subscription.stats
    generate_test_report(stats, :usage)

    expect(stats.total_time.round).to eq(23)

    highest_count = stats.highest_count(1).first
    expect(highest_count.name).to eq(:profile)
    expect(highest_count.count).to eq(4)

    highest_total_time = stats.highest_total_time(1).first
    expect(highest_total_time.name).to eq(:organization)
    expect(highest_total_time.total_time.round).to eq(16)

    highest_self_time = stats.highest_self_time(1).first
    expect(highest_self_time.name).to eq(:user)
    expect(highest_self_time.total_self_time.round).to eq(9)

    highest_average_time = stats.highest_average_time(1).first
    expect(highest_average_time.name).to eq(:repository)
    expect(highest_average_time.average_time.round).to eq(14)
  end

  it "reports with traits" do
    define_class("Car") do
      attr_accessor :moon_roof, :flatscreen_tv, :seat_warmer

      def save!
        Timecop.travel(Time.now + 4)
      end
    end

    define_class("MoonRoof") do
      def save!
        Timecop.travel(Time.now + 3)
      end
    end

    define_class("FlatscreenTv") do
      def save!
        Timecop.travel(Time.now + 2)
      end
    end

    define_class("SeatWarmer") do
      def save!
        Timecop.travel(Time.now + 1)
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

    subscription = FactoryBotProfile.subscribe

    FactoryBot.create(:car)
    FactoryBot.create(:car, :ex)
    FactoryBot.create(:car, :lx)

    subscription.unsubscribe
    stats = subscription.stats
    generate_test_report(stats, :usage_with_traits)

    expect(stats.total_time.round).to eq(21)

    highest_total_time = stats.highest_total_time(1).first
    expect(highest_total_time.name).to eq(:car)

    child_times = highest_total_time.child_stats.transform_values(&:total_time)
    expect(child_times[:moon_roof].round).to eq(6)
    expect(child_times[:flatscreen_tv].round).to eq(2)
    expect(child_times[:seat_warmer].round).to eq(1)

    child_average_times = highest_total_time.child_stats.transform_values(&:average_time)
    expect(child_average_times[:moon_roof].round).to eq(3)
    expect(child_average_times[:flatscreen_tv].round).to eq(2)
    expect(child_average_times[:seat_warmer].round).to eq(1)

    child_counts = highest_total_time.child_stats.transform_values(&:count)
    expect(child_counts[:moon_roof]).to eq(2)
    expect(child_counts[:flatscreen_tv]).to eq(1)
    expect(child_counts[:seat_warmer]).to eq(1)
  end

  private

  def define_class(name, parent = Object, &block)
    stub_const(name, Class.new(parent)).tap do |const|
      const.class_eval(&block) if block
    end
  end

  before(:all) do
    FileUtils.mkdir_p("tmp/test_reports")
  end

  def generate_test_report(stats, name)
    File.open("tmp/test_reports/#{name}.txt", "w") do |f|
      FactoryBotProfile.report(stats, io: f, count: 4)
    end
  end
end
