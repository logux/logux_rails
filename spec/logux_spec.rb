# frozen_string_literal: true

describe Logux, timecop: true do
  it 'has a version number' do
    expect(Logux::VERSION).not_to be nil
  end
end
