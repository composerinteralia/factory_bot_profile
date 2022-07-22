# frozen_string_literal: true

RSpec.describe FactoryBotProfiler::Stack do
  it "pushes and pops" do
    stack = FactoryBotProfiler::Stack.new
    name = :name

    stack << name
    frame = stack.pop

    expect(frame.name).to eq(name)
  end

  it "finishes frame when popping" do
    stack = FactoryBotProfiler::Stack.new
    name = :name
    duration = 42

    stack << name
    frame = Timecop.travel(Time.now + duration) do
      stack.pop
    end

    expect(frame.duration.round).to eq(duration)
  end

  it "allows parent frame to observe child frames" do
    stack = FactoryBotProfiler::Stack.new
    parent_name = :parent
    child_name = :child

    stack << parent_name
    stack << child_name
    child_frame = stack.pop
    parent_frame = stack.pop

    expect(parent_frame.child_time[child_frame.name]).to eq(child_frame.duration)
  end
end
