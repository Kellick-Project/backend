class ApiController < ApplicationController::API
  # before_action :authenticate_user

  def fetch_data
    token = OAuth2::AccessToken.new($iras_oauth_client, session[:access_token])

    # Replace with the correct IRAS API endpoint you wish to access
    response = token.get('https://apiservices.iras.gov.sg/iras/prod/ct/GetReturnStatus') 

    if response.status == 200
      # Parse and render the API response
      render json: response.parsed
    else
      # Handle API errors
      render plain: "API call failed: #{response.status} - #{response.body}"
    end
  rescue OAuth2::Error => e
    render plain: "OAuth error: #{e.message}"
  end

  private

  def authenticate_user
    # Ensure that the user is authenticated and has a valid token
    redirect_to login_path unless session[:access_token]
  end
end