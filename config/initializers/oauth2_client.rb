require 'oauth2'

IRAS_AUTH_URL = 'https://apiservices.iras.gov.sg/iras/sb/Authentication/CorpPassAuth'  # Authorization server
IRAS_TOKEN_URL = 'https://apiservices.iras.gov.sg/iras/sb/Token'  # Token endpoint

$iras_oauth_client = OAuth2::Client.new(
  ENV['IRAS_CLIENT_ID'],
  ENV['IRAS_CLIENT_SECRET'],
  site: 'https://apiservices.iras.gov.sg',
  authorize_url: '/iras/sb/Authentication/CorpPassAuth',
  token_url: '/iras/sb/Token'
)
