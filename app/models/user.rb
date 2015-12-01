class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true
  before_save :downcase_login, :create_login_md5
  # Some validation messages have been logalized at:
  # config/locales/en.yml
  
  validates :login,
    presence: true,
    length: {
      within: 6..20,
      too_short: 'Usename must be at least 6 characters long.',
      too_long: 'Username may be no more than 20 characters long.'
    }

  validates :password,
    presence: true,
    length: {
      within: 8..50,
      too_short: 'Password must be at least 8 characters long.',
      too_long: 'Password may be no more than 50 characters long.'
    },
    format: {
      # I lost two hours of my life to this line. :|
      # validates_format_of :password, with: /\A3\z/
      with: /\A[A-Za-z]\w+/,
      message: 'Username must begin with a letter and contain only letters, underscores or numbers.'
    }

  validates_confirmation_of :password,
    message: 'Password confirmation does not match the password.'

  validates :email,
    presence: true,
    length: {
      within: 6..40,
      too_short: 'Email must be at least 6 characters long.',
      too_long: 'Email may be no more thna 40 characters long.'
    },
    format: {
      # I've been through this in practice. Email regex is a nightmare unless
      # you KISS. This enforces *at least* a@b.c
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
