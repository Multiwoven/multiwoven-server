unless Rails.env.test?
  require 'opentelemetry/sdk'
  require 'opentelemetry/instrumentation/all'
  require 'opentelemetry-exporter-otlp'
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "multiwoven-#{Rails.env}"

    c.use 'OpenTelemetry::Instrumentation::ActiveSupport'
    c.use 'OpenTelemetry::Instrumentation::Rack', {allowed_request_headers: [], allowed_response_headers: [], application: nil, record_frontend_span: false, untraced_endpoints: [], url_quantization: nil, untraced_requests: nil, response_propagators: [], use_rack_events: true, allowed_rack_request_headers: {}, allowed_rack_response_headers: {}}
    c.use 'OpenTelemetry::Instrumentation::ActionPack'
    c.use 'OpenTelemetry::Instrumentation::ActiveJob', {propagation_style: :link, force_flush: false, span_naming: :queue}
    c.use 'OpenTelemetry::Instrumentation::ActiveRecord'
    c.use 'OpenTelemetry::Instrumentation::ActionView', {disallowed_notification_payload_keys: [], notification_payload_transform: nil}
    c.use 'OpenTelemetry::Instrumentation::AwsSdk', {inject_messaging_context: false, suppress_internal_instrumentation: false}
    c.use 'OpenTelemetry::Instrumentation::ActiveModelSerializers'
    c.use 'OpenTelemetry::Instrumentation::ConcurrentRuby'
    c.use 'OpenTelemetry::Instrumentation::Faraday', {span_kind: :client, peer_service: nil}
    c.use 'OpenTelemetry::Instrumentation::HttpClient'
    c.use 'OpenTelemetry::Instrumentation::Net::HTTP', {untraced_hosts: []}
    c.use 'OpenTelemetry::Instrumentation::PG', {peer_service: nil, db_statement: :obfuscate, obfuscation_limit: 2000}
    c.use 'OpenTelemetry::Instrumentation::Rails'
  end
end

