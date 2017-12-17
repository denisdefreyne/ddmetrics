# frozen_string_literal: true

describe DDTelemetry::Summary do
  subject(:summary) { described_class.new }

  describe '#get' do
    subject { summary.get(:erb) }

    before do
      summary.observe(2.1, :erb)
      summary.observe(4.1, :erb)
      summary.observe(5.3, :haml)
    end

    it { is_expected.to be_a(DDTelemetry::Stats) }

    its(:sum) { is_expected.to eq(2.1 + 4.1) }
    its(:count) { is_expected.to eq(2) }
  end

  describe '#labels' do
    subject { summary.labels }

    before do
      summary.observe(2.1, :erb)
      summary.observe(4.1, :erb)
      summary.observe(5.3, :haml)
    end

    it { is_expected.to contain_exactly(:haml, :erb) }
  end

  describe '#each' do
    subject do
      {}.tap do |res|
        summary.each { |label, stats| res[label] = stats.avg.round(2) }
      end
    end

    before do
      summary.observe(2.1, :erb)
      summary.observe(4.1, :erb)
      summary.observe(5.3, :haml)
    end

    it { is_expected.to eq(haml: 5.3, erb: 3.1) }

    it 'is enumerable' do
      expect(summary.map { |_label, stats| stats.sum }.sort)
        .to eq([5.3, 2.1 + 4.1])
    end
  end

  describe '#to_s' do
    subject { summary.to_s }

    before do
      summary.observe(2.1, :erb)
      summary.observe(4.1, :erb)
      summary.observe(5.3, :haml)
    end

    it 'returns table' do
      expected = <<~TABLE
             │ count    min    .50    .90    .95    max    tot
        ─────┼────────────────────────────────────────────────
         erb │     2   2.10   3.10   3.90   4.00   4.10   6.20
        haml │     1   5.30   5.30   5.30   5.30   5.30   5.30
      TABLE

      expect(subject.strip).to eq(expected.strip)
    end
  end
end
