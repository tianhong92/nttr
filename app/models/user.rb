class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true
  before_save :create_login_md5

  # Some validation messages have been logalized at:
  # config/locales/en.yml
  
  validates_format_of :password, with: /\A3\z/

  acts_as_authentic do |opts|
    opts.merge_validates_length_of_password_field_options({ 
      minimum: 8,
      message: 'Password must be at least 8 characters long.'
    })

    opts.merge_validates_length_of_login_field_options({
      minimum: 6,
      message: 'Username must be at least 6 characters long.'
    })

    opts.merge_validates_format_of_email_field_options({
      # I've been through this in practice. Email regex is a nightmare unless
      # you KISS. This enforces *at least* a@b.c
      # 
      # There exists national-level single-letter domains and two-letter TLDs.
      #
      # See: http://davidcel.is/posts/stop-validating-email-addresses-with-regex
      # See: https://regex101.com/r/jS2rV9/1
      with: /\A.+@.+\..+\z/,
      message: 'Your email must be in the format of foo@bar.tld.'
    })
  end

  private
    def self.find_by_login_or_email(login)
      find_by_login(login) || find_by_email(login)
    end

    def create_login_md5
      self.login_md5 = Digest::MD5.hexdigest(self.login)
    end
end
