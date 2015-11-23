class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  accepts_nested_attributes_for :tweets, allow_destroy: true

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
end
