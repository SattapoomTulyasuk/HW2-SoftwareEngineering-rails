OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '409805368031649', '6241c696afe0ec47fa63994f16f10cf8'
end