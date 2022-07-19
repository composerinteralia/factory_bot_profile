# frozen_string_literal: true

RSpec.describe FactoryBotProfiler do
  it "reports factory usage" do
    expect(FactoryBotProfiler::VERSION).not_to be nil
  end
end
