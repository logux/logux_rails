# frozen_string_literal: true

require 'rails_helper'

describe 'rake logux:actions', type: :task do
  subject(:task) { Rake::Task['logux:actions'] }

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  # rubocop:disable RSpec/ExampleLength
  it 'outputs all action types and corresponding class and method names' do
    expect { task.execute }.to output(
      <<~TEXT
           action.type Class#method
        blog/notes/add Actions::Blog::Notes#add
           comment/add Actions::Comment#add
           post/rename Actions::Post#rename
            post/touch Actions::Post#touch
      TEXT
    ).to_stdout
  end
  # rubocop:enable RSpec/ExampleLength
end
