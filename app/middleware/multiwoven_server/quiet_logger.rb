# app/middleware/multiwoven_server/quiet_logger.rb
module MultiwovenServer
  class QuietLogger < Rails::Rack::Logger
    def call(env)
      previous_level = Rails.logger.level
      if env['PATH_INFO'] == '/'
        Rails.logger.level = Logger::ERROR
      end
      super(env)
    ensure
      Rails.logger.level = previous_level
    end
  end
end