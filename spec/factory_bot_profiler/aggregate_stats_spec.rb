# frozen_string_literal: true

RSpec.describe FactoryBotProfiler::AggregateStats do
  it "serializes via Marshal" do
    stats = FactoryBotProfiler::AggregateStats.new
    frame = FactoryBotProfiler::Frame.new(:test).tap(&:finish!)
    stats.collect(frame)

    marshal_stats = Marshal.load(Marshal.dump(stats))

    expect(stats.total_time).not_to eq(0)
    expect(marshal_stats.total_time).to eq(stats.total_time)
  end
end
