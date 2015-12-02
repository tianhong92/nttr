class UserSession < Authlogic::Session::Base
  # Authlogic handles session validation internally. Custom error messages have
  # been input in:
  #
  #   config/locales/en.yml
  #
  # A ist of complete error messages can be found at: 
  # See: http://www.rubydoc.info/github/binarylogic/authlogic/Authlogic/I18n
  find_by_login_method :find_by_login_or_email
end
