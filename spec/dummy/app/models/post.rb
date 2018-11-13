# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Logux::Model

  logux_crdt_map_attributes :title, :content
end
