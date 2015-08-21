Rails.application.config.middleware.use OmniAuth::Builder do
  provider :steam, Settings[:steam][:api_key]
end
