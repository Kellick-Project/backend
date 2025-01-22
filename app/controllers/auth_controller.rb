class AuthController < ApplicationController

  
  
  def login
    redirect_to $iras_oauth_client.auth_code.authorize_url(
      redirect_uri: callback_url,
      scope: 'required_scope'
      )
    end

  def callback
    if params[:code]
      token = $iras_oauth_client.auth_code.get_token(
        params[:code],
        redirect_uri: callback_url
      )
    
      session[:access_token] = token.token
      redirect_to dashboard_path
    else
      render plain: "Authorization code missing"
    end
  rescue OAuth2::Error => e
    render plain: "Authentication failed: #{e.message}"
  end
  

  private

  def callback_url
    url_for(action: :callback, controller: :auth, only_path: false)
  end
end
