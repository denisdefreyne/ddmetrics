# frozen_string_literal: true

describe DDTelemetry::Summary do
  subject(:summary) { described_class.new }

  describe '#empty?' do
    subject { summary.empty? }

    context 'empty summary' do
      it { is_expected.to be }
    end

    context 'some observations' do
      before do
        summary.observe(7.2, :erb)
        summary.observe(5.3, :erb)
        summary.observe(3.0, :haml)
      end

      it { is_expected.not_to be }
    end
  end

  describe '#get' do
    subject { summary.get(:erb) }

    context 'empty summary' do
      its(:values) { is_expected.to eq([]) }
    end

    context 'one observation with that label' do
      before { summary.observe(0.1, :erb) }
      its(:values) { is_expected.to eq([0.1]) }
    end

    context 'one observation with a different label' do
      before { summary.observe(0.1, :haml) }
      its(:values) { is_expected.to eq([]) }
    end
  end

  describe '#map' do
    before do
      subject.observe(2.1, :erb)
      subject.observe(4.1, :erb)
      subject.observe(5.3, :haml)
    end

    it 'yields label and summary' do
      res = subject.map { |label, summary| [label, summary.values] }
      expect(res).to eql([[:erb, [2.1, 4.1]], [:haml, [5.3]]])
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
