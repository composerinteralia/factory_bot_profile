# frozen_string_literal: true

RSpec.describe FactoryBotProfiler::FactoryStat do
  it "serializes via Marshal" do
    stat = FactoryBotProfiler::FactoryStat.new(:test)

    marshal_stat = Marshal.load(Marshal.dump(stat))

    expect(marshal_stat.name).to eq(stat.name)
  end
end
