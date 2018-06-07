# frozen_string_literal: true

Logux::Engine.routes.draw do
  resource :logux, only: %i[create], controller: :logux
end
