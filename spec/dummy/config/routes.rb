# frozen_string_literal: true

Rails.application.routes.draw do
  resource :logux, only: %i[create], controller: :logux
end
