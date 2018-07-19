# frozen_string_literal: true

describe DDMetrics::Counter do
  subject(:counter) { described_class.new }

  describe 'new counter' do
    it 'starts at 0' do
      expect(subject.get(filter: :erb)).to eq(0)
      expect(subject.get(filter: :haml)).to eq(0)
    end
  end

  describe '#increment' do
    subject { counter.increment(filter: :erb) }

    it 'increments the matching value' do
      expect { subject }
        .to change { counter.get(filter: :erb) }
        .from(0)
        .to(1)
    end

    it 'does not increment any other value' do
      expect(counter.get(filter: :haml)).to eq(0)
      expect { subject }
        .not_to change { counter.get(filter: :haml) }
    end

    context 'non-hash label' do
      subject { counter.increment('WRONG UGH') }

      it 'errors' do
        expect { subject }.to raise_error(ArgumentError, 'label argument must be a hash')
      end
    end
  end

  describe '#get' do
    subject { counter.get(filter: :erb) }

    context 'not incremented' do
      it { is_expected.to eq(0) }
    end

    context 'incremented' do
      before { counter.increment(filter: :erb) }
      it { is_expected.to eq(1) }
    end

    context 'other incremented' do
      before { counter.increment(filter: :haml) }
      it { is_expected.to eq(0) }
    end
  end

  describe '#labels' do
    subject { counter.labels }

    before do
      counter.increment(filter: :erb)
      counter.increment(filter: :erb)
      counter.increment(filter: :haml)
    end

    it { is_expected.to match_array([{ filter: :haml }, { filter: :erb }]) }
  end

  describe '#each' do
    subject do
      {}.tap do |res|
        counter.each { |label, count| res[label] = count }
      end
    end

    before do
      counter.increment(filter: :erb)
      counter.increment(filter: :erb)
      counter.increment(filter: :haml)
    end

    it { is_expected.to eq({ filter: :haml } => 1, { filter: :erb } => 2) }

    it 'is enumerable' do
      expect(counter.map { |_label, count| count }.sort)
        .to eq([1, 2])
    end
  end

  describe '#to_s' do
    subject { counter.to_s }

    before do
      counter.increment(filter: :erb)
      counter.increment(filter: :erb)
      counter.increment(filter: :haml)
    end

    it 'returns table' do
      expected = <<~TABLE
        filter │ count
        ───────┼──────
           erb │     2
          haml │     1
      TABLE

      expect(subject.strip).to eq(expected.strip)
    end
  end
end
