# frozen_string_literal: true

Logux::Engine.routes.draw do
  mount Logux::Rack::App => '/'
end
