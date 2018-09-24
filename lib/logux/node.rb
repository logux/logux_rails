# frozen_string_literal: true

module Logux
  class Node
    include Singleton

    attr_accessor :last_time, :sequence
    attr_writer :node_id

    def generate_action_id
      mutex.synchronize do
        if last_time && now_time <= last_time
          @sequence += 1
        else
          @sequence = 0
          @last_time = now_time
        end

        "#{last_time} #{node_id} #{sequence}"
      end
    end

    def node_id
      @node_id ||= "server:#{Nanoid.generate(size: 8)}"
    end

    private

    def now_time
      Time.now.to_datetime.strftime('%Q')
    end

    def mutex
      @mutex ||= Mutex.new
    end
  end
end
