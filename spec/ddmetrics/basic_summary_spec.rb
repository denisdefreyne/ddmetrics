# frozen_string_literal: true

describe DDMetrics::BasicSummary do
  subject(:summary) { described_class.new }

  context 'no observations' do
    its(:values) { is_expected.to be_empty }
  end

  context 'one observation' do
    before { subject.observe(2.1) }
    its(:values) { is_expected.to eq([2.1]) }
  end

  context 'two observations' do
    before do
      subject.observe(2.1)
      subject.observe(4.1)
    end

    its(:values) { is_expected.to eq([2.1, 4.1]) }
  end
end
