class User < ApplicationRecord
  before_save { self.email.downcase! } #self is optional on the right hand side!

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true
end
