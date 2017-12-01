# frozen_string_literal: true

describe DDTelemetry::Table do
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
end
