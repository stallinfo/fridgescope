class FacilityManager < ApplicationRecord
  attr_accessor :remember_token
  #before_save { self.email = email.downcase }
  belongs_to :facility
  validates :name, presence: false, length: { maximum: 80 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: false, length: { maximum: 80 },
  #  format: { with: VALID_EMAIL_REGEX },
  #  uniqueness: true
  validates :email, presence: false, uniqueness: false
  validates :identify, presence: false, length: { maximum: 20 }
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  validates :created_api_caller, presence: false, length: { maximum: 80 }
  validates :updated_api_caller, presence: false, length: { maximum: 80 }
  has_secure_password
  validates :password, presence: false, length: { minimum: 6 }, allow_nil: true
  
  def FacilityManager.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost) 
  end
  
  # Returns a random token.
  def FacilityManager.new_token 
    SecureRandom.urlsafe_base64
  end

  def remember 
    self.remember_token = FacilityManager.new_token
    update_attribute(:remember_digest, FacilityManager.digest(remember_token))
  end

  def authenticated?(remember_token) 
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
