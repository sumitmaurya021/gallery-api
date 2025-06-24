# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :role, inclusion: { in: %w[admin user], message: "%{value} is not a valid role" }

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
