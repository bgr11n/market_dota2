Rails.application.config.api = YAML.load_file("#{Rails.root}/config/api.yml")[Rails.env]
