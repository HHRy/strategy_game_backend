# frozen_string_literal: true

class TestHarness
  include StrategyGameBackend::Behaviours::Movable
end

RSpec.describe StrategyGameBackend::Behaviours::Movable do
  it "raises errors when not properly initialized with an initial location" do
    subject = TestHarness.new

    expect { subject.position }.to raise_error(StrategyGameBackend::Behaviours::Movable::Error)
    expect(subject.can_move?).to eq(false)
    expect { subject.move(-1,2) }.to raise_error(StrategyGameBackend::Behaviours::Movable::Error)
  end

  it "can move when the item has a position" do
    subject = TestHarness.new
    subject.set_current_position(1,2)

    expect(subject.can_move?).to eq(true)
  end

end
