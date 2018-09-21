# frozen_string_literal: true

require 'rails_helper'

describe 'rake logux:actions', type: :task do
  subject(:task) { Rake::Task['logux:actions'] }

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'outputs all action types and corresponding class and method names' do
    expect { task.execute }.to output(
      "   action.type Class#method\n"\
      "blog/notes/add Actions::Blog::Notes#add\n"\
      "   comment/add Actions::Comment#add\n"
    ).to_stdout
  end
end
