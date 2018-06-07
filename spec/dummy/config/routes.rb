# frozen_string_literal: true

Rails.application.routes.draw do
  mount Logux::Engine => '/'
end
