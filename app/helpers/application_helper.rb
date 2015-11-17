module ApplicationHelper
  require 'digest/md5'

  def adorable_avatar(user, size = 75)
    # Send out MD5 of email for avatar. No need to use user info.
    # Will give consistent avatars per run.
    avatar = Digest::MD5.hexdigest(user.email)

    # Question: Is this insertion correct?
    src = "http://api.adorable.io/avatars/#{size}/#{avatar}.png"
    alt = "#{user.login}'s handsome avatar."

    link_to image_tag(src, alt: alt), user_path(user)
  end
end
