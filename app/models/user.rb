class User < ActiveRecord::Base
  has_secure_password
  # attr_accessor :name, :email
  # before_save { self.email = email.downcase }
  has_many :microposts
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true


end
