# config/initializers/load_tracker_config.rb
TRACKER = YAML.load_file(Rails.root.join('config/tracker_config.yml')).freeze
