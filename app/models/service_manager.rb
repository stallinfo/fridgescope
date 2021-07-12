class ServiceManager < ApplicationRecord
  attr_accessor :remember_token
  belongs_to :service
  validates :name, presence: true, length: { maximum: 60 }
  validates :identify, presence: true, length: { maximum: 20 }
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  has_secure_password
  validates :password, presence: false, length: { minimum: 6 }, allow_nil: true
  
  def ServiceManager.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost) 
  end
  
  # Returns a random token.
  def ServiceManager.new_token 
    SecureRandom.urlsafe_base64
  end

  def remember 
    self.remember_token = ServiceManager.new_token
    update_attribute(:remember_digest, ServiceManager.digest(remember_token))
  end
  
  def authenticated?(remember_token) 
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
