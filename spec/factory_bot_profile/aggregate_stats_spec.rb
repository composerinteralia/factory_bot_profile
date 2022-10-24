# frozen_string_literal: true

RSpec.describe FactoryBotProfile::AggregateStats do
  it "serializes via Marshal" do
    stats = FactoryBotProfile::AggregateStats.new
    frame = FactoryBotProfile::Frame.new(:test).tap(&:finish!)
    stats.collect(frame)

    marshal_stats = Marshal.load(Marshal.dump(stats))

    expect(stats.total_time).not_to eq(0)
    expect(marshal_stats.total_time).to eq(stats.total_time)
  end
end
