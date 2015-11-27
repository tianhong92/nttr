class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true
  before_save :create_login_md5

  acts_as_authentic do |opts|
    opts.merge_validates_length_of_password_field_options({ 
      minimum: 8,
      message: 'Your password is too short!'
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
