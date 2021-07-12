class Administrator < ApplicationRecord
    attr_accessor :remember_token
    validates :name, presence: false, length: { maximum: 60 }
    validates :identify, presence: false, length: { maximum: 20 }
    has_secure_password
    validates :password, presence: false, length: { minimum: 6 }, allow_nil: true
    
    def Administrator.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost) 
    end

    # Returns a random token.
    def Administrator.new_token 
        SecureRandom.urlsafe_base64
    end

    def remember 
        self.remember_token = Administrator.new_token
        update_attribute(:remember_digest, Administrator.digest(remember_token))
    end

    def authenticated?(remember_token) 
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
