# frozen_string_literal: true

class TestHarness
  include StrategyGameBackend::Behaviours::Destructable
end

RSpec.describe StrategyGameBackend::Behaviours::Destructable do
  it "raises errors when not properly initialized with health" do
    subject = TestHarness.new

    expect { subject.destructable? }.to raise_error(StrategyGameBackend::Behaviours::Destructable::Error)
    expect { subject.take_damage(3) }.to raise_error(StrategyGameBackend::Behaviours::Destructable::Error)
    expect { subject.destroyed? }.to raise_error(StrategyGameBackend::Behaviours::Destructable::Error)
    expect { subject.repairable? }.to raise_error(StrategyGameBackend::Behaviours::Destructable::Error)
    expect { subject.repair(3) }.to raise_error(StrategyGameBackend::Behaviours::Destructable::Error)
  end

  it "is destroyed with health is zero" do
    subject = TestHarness.new
    subject.set_initial_health(100)

    subject.take_damage(50)

    expect(subject.destroyed?).to eq(false)
    expect(subject.health).to eq(50)

    subject.take_damage(50)
    expect(subject.destroyed?).to eq(true)
    expect(subject.health).to eq(0)
  end

  it "is repairable when health is less than initial health" do
    subject = TestHarness.new
    subject.set_initial_health(100)

    expect(subject.repairable?).to eq(false)

    subject.take_damage(50)

    expect(subject.repairable?).to eq(true)
  end

  it "will not repair beyond initial health" do
    subject = TestHarness.new
    subject.set_initial_health(100)
    subject.take_damage(50)

    expect(subject.health).to eq(50)
    expect(subject.repairable?).to eq(true)

    subject.repair(4000)

    expect(subject.health).to eq(100)
    expect(subject.repairable?).to eq(false)
  end

  it "is not destructable when it is destroyed" do
    subject = TestHarness.new
    subject.set_initial_health(100)

    expect(subject.destructable?).to eq(true)
    expect(subject.destroyed?).to eq(false)

    subject.take_damage(100)

    expect(subject.destructable?).to eq(false)
    expect(subject.destroyed?).to eq(true)
  end
end
