# frozen_string_literal: true

class LoguxController < ApplicationController
  def create
    render Logux.process_batch(params)
  end
end
