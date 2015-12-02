class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true
  before_save :downcase_login, :create_login_md5

  acts_as_authentic do |opts|
    #
    # Login
    #
    # Twitter allows usernames to contian any word char (A-Za-z0-9_) with a
    # minimum length of 1. These short names are considered to be desireable
    # and can sell for many monies.
    #
    # @_, @3, @_____, @______1 are all valid (and used) Twitter usernames.
    #
    # See: http://goo.gl/FMdLB0
    #
    # Twitter username length is inclusively in 1 - 15 characters.
    # See: https://support.twitter.com/articles/14609
    #

    opts.merge_validates_format_of_login_field_options({
      with: /\A\w+\z/,
      message: 'Usernames may contain only letters, numbers and underscores.'
    })

    opts.merge_validates_length_of_login_field_options({
      in: 1..15,
      too_short: 'Usename must be at least 1 character long.',
      too_long: 'Username may be no more than 15 characters long.'
    })

    #
    # Email 
    #
    # I've been through this in practice. Email regex is a nightmare unless
    # you KISS. This enforces *at least* a@t.co (which is a valid email
    # associated with the Twitter company).
    # 
    # There exists national-level single-letter domains and two-letter TLDs.
    #
    # See: http://davidcel.is/posts/stop-validating-email-addresses-with-regex
    # See: https://regex101.com/r/jS2rV9/1
    #

    opts.merge_validates_format_of_email_field_options({
      with: /\A.+@.+\..+\z/,
      message: 'Email must be in the format of \'foo@bar.tld\'.'
    })

    opts.merge_validates_length_of_email_field_options({
      in: 6..40,
      too_short: 'Email must be at least 6 characters long.',
      too_long: 'Email may be no more than 40 characters long.'
    })

    #
    # Password
    #
    # There is no format validation in Authlogic except: a password must contain
    # at least one non-space character and meet length requirements. This worked
    # as a password in testing (within quotes):
    #
    # '       8'
    #
    # /[^\s]/
    #

    opts.merge_validates_length_of_password_field_options({
      # Authlogic's default password is 4 characters.
      minimum: 8,
      message: 'Password must be at least 8 characters long.'
    })

    opts.merge_validates_confirmation_of_password_field_options({
      # Validate presence of password confirmation. Defaults to an unhelpful
      # 'password must be n characters' message.
      message: 'Input passwords do not match.'
    })

    opts.merge_validates_length_of_password_confirmation_field_options({
      # By default this will repeat the message in the above method.
      message: 'You must confirm your password.'
    })
  end
    
  def to_param
    login
  end

  private
    def self.find_by_login_or_email(login)
      find_by_login(login) || find_by_email(login)
    end

    def create_login_md5
      self.login_md5 = Digest::MD5.hexdigest(self.login)
    end

    def downcase_login
      self.login = self.login.downcase
    end
end
