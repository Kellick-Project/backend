class User < ApplicationRecord
  def iras_token_expired?
    iras_expires_at && iras_expires_at < Time.current
  end

  def refresh_iras_token!
    return unless iras_refresh_token

    client = OAuth2::AccessToken.new(IRAS_OAUTH_CLIENT, iras_refresh_token, refresh_token: iras_refresh_token)
    new_token = client.refresh!

    update(
      iras_access_token: new_token.token,
      iras_refresh_token: new_token.refresh_token,
      iras_expires_at: Time.at(new_token.expires_at)
    )
  end
end
