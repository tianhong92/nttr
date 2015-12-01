class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true
  before_save :downcase_login, :create_login_md5
  
  validates :login,
    presence: true,
    length: {
      # Twitter allows usernames to contian any word char with a minimum length
      # of 1. These short names are considered to be desireable and can sell
      # for many monies.
      #
      # @_, @3, @_____, @______1 are all valid (and used) Twitter usernames.
      #
      # See: http://goo.gl/FMdLB0
      in: 1..15,
      too_short: 'Usename must be at least 1 character long.',
      too_long: 'Username may be no more than 15 characters long.'
    },
    format: {
      with: /\A\w+\z/,
      message: 'Usernames may contain only letters, underscores or numbers.'
    }

  validates :password,
    presence: true,
    confirmation: true,
    length: {
      in: 8..100,
      too_short: 'Password must be at least 8 characters long.',
      too_long: 'Password may be no more than 100 characters long.'
    }
    # format: {
    #  # I lost two hours of my life to this line. :|
    #  # with: /\A3\z/
    # }

  validates :password_confirmation, 
    presence: true

  validates :email,
    presence: true,
    length: {
      in: 6..40,
      too_short: 'Email must be at least 6 characters long.',
      too_long: 'Email may be no more than 40 characters long.'
    },
    format: {
      # I've been through this in practice. Email regex is a nightmare unless
      # you KISS. This enforces *at least* a@t.co (which is a valid email
      # associated with the Twitter company).
      # 
      # There exists national-level single-letter domains and two-letter TLDs.
      #
      # See: http://davidcel.is/posts/stop-validating-email-addresses-with-regex
      # See: https://regex101.com/r/jS2rV9/1
      with: /\A.+@.+\..+\z/,
      message: 'Email must be in the format of foo@bar.tld.'
    }

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
