# frozen_string_literal: true

module Logux
  module Test
    module Helpers
      module Receive
        LOGUX_VERSION = 0

        RSpec::Matchers.define :be_approved do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first.in?(%w[forbidden error]) }.nil? &&
              @actual.find { |res| res.first == 'approved' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be approved " \
            "and doesn't be errored of forbidden"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        RSpec::Matchers.define :be_processed do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first.in?(%w[forbidden error]) }.nil? &&
              @actual.find { |res| res.first == 'processed' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be processed " \
            "and doesn't be errored of forbidden"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        RSpec::Matchers.define :be_forbidden do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first == 'forbidden' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be forbidden"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        RSpec::Matchers.define :be_errored do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first == 'error' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be errored"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        RSpec::Matchers.define :be_authenticated do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first == 'authenticated' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be authenticated"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        RSpec::Matchers.define :be_denied do
          match do |actual|
            @actual = actual
            @actual.find { |res| res.first == 'denied' }
          end

          failure_message do
            "expected that #{pretty(@actual)} to be denied"
          end

          def pretty(obj)
            JSON.pretty_generate(obj)
          end
        end

        def receive_subscription(data: {},
                                 meta: {},
                                 password: Logux.configuration.password,
                                 version: LOGUX_VERSION)
          receive_action(data: { type: 'logux/subscribe' }.merge(data),
                         meta: meta,
                         password: password,
                         version: version)
        end

        def receive_action(data:,
                           meta: {},
                           password: Logux.configuration.password,
                           version: LOGUX_VERSION)
          meta = Logux::Meta.new(meta)
          params = default_params(password, version).merge(
            commands: format(data: data, meta: meta, type: 'action')
          )

          post('/logux',
               params: params,
               as: :json)

          JSON.parse(response.stream.body)
        end

        def receive_auth(data:,
                         password: Logux.configuration.password,
                         version: LOGUX_VERSION)
          params = default_params(password, version).merge(
            commands: [['auth'] + data]
          )

          post('/logux',
               params: params,
               as: :json)

          JSON.parse(response.stream.body)
        end

        def default_params(password, version)
          { version: version,
            password: password }
        end

        def format(data:, meta:, type:)
          case data
          when Array
            data.map do |chunk|
              [type, chunk, { id: Logux.generate_action_id }.merge(meta)]
            end
          when Hash
            [[type, data, meta]]
          else
            raise NotImplementedError
          end
        end
      end
    end
  end
end
