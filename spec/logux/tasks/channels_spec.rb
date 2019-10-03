# frozen_string_literal: true

require 'rails_helper'

describe 'rake logux:channels', type: :task do
  subject(:task) { Rake::Task['logux:channels'] }

  it 'outputs all channels and corresponding class names' do
    expect { task.execute }.to output(
      /post Channels::Post/
    ).to_stdout
  end
end
