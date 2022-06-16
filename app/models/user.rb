class User < ApplicationRecord
  before_save { self.email.downcase! } #self is optional on the right hand side!
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
      : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
