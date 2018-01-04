# frozen_string_literal: true

describe DDMetrics::Table do
  let(:table) { described_class.new(rows) }

  let(:rows) do
    [
      %w[name awesomeness],
      %w[denis high],
      %w[REDACTED low],
    ]
  end

  example do
    expect(table.to_s).to eq(<<~TABLE.rstrip)
          name │ awesomeness
      ─────────┼────────────
         denis │        high
      REDACTED │         low
    TABLE
  end

  context 'unsorted data' do
    let(:rows) do
      [
        %w[name awesomeness],
        %w[ccc highc],
        %w[bbb highb],
        %w[ddd highd],
        %w[eee highe],
        %w[aaa higha],
      ]
    end

    example do
      expect(table.to_s).to eq(<<~TABLE.rstrip)
        name │ awesomeness
        ─────┼────────────
         aaa │       higha
         bbb │       highb
         ccc │       highc
         ddd │       highd
         eee │       highe
      TABLE
    end
  end
end
