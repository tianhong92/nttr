module ApplicationHelper
  def adorable_avatar(user, size = 75)
    # Send out MD5 of email for avatar. No need to use user info.
    # Will give consistent avatars per run.
    avatar = user.login_md5

    # Question: Is this insertion correct?
    src = "http://api.adorable.io/avatars/#{size}/#{avatar}.png"
    alt = "#{user.login}'s handsome avatar."
    size = "#{size}x#{size}"

    link_to image_tag(src, alt: alt, size: size), user_path(user)
  end
end
