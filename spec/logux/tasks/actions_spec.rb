# frozen_string_literal: true

require 'rails_helper'

describe 'rake logux:actions', type: :task do
  subject(:task) { Rake::Task['logux:actions'] }

  it 'outputs all action types and corresponding class and method names' do
    expect { task.execute }.to output(
      %r{blog/notes/add Actions::Blog::Notes#add}
    ).to_stdout
  end
end
