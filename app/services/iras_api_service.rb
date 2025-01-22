class IrasApiService
  include HTTParty
  base_uri 'https://apiservices.iras.gov.sg/'

  def initialize
    @client_id = ENV['IRAS_CLIENT_ID']
    @client_secret = ENV['IRAS_CLIENT_SECRET']
    @redirect_uri = ENV['IRAS_REDIRECT_URI']
    @auth_code = ENV['IRAS_AUTH_CODE'] # You need to have this from the OAuth flow
    @token = fetch_access_token
  end

  def fetch_tax_records

    response = self.class.get(
      '/iras/prod/DataCollectionReconProcess',
      headers: { 'Authorization' => "Bearer #{@token}" }
    )
    handle_response(response)
  end

  def get_return_status(request_body)
    response = self.class.post(
      '/iras/prod/ct/GetReturnStatus',
      headers: {
        "X-IBM-Client-Id" => @client_id,
        "X-IBM-Client-Secret" => @client_secret,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      },
      body: request_body
    )
    handle_response(response)
  end

  private

  def fetch_access_token
    body = {
      "grant_type" => "authorization_code",
      "client_id" => @client_id,
      "client_secret" => @client_secret,
      "redirect_uri" => @redirect_uri,
      "code" => @auth_code
    }

    response = self.class.post('/iras/oauth2/token', body: body)
    if response.success?
      JSON.parse(response.body)["access_token"]
    else
      handle_error(response)
    end
  end

  def handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      handle_error(response)
    end
  end

  def handle_error(response)
    error_message = JSON.parse(response.body).fetch("error_description", "Unknown error")
    Rails.logger.error("IRAS API Error: #{error_message}")
    raise "Error fetching data from IRAS API: #{error_message}"
  end
end


  