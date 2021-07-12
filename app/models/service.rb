class Service < ApplicationRecord
    has_many :service_managers, dependent: :destroy
    has_many :facilities, dependent: :destroy
    validates :connection_phrase, presence: true, length: { maximum: 16 }
    validates :name, presence: true, length: { maximum: 60 }
    validates :description, presence: false, length: { maximum: 200 }
    validates :created_by, presence: false, length: { maximum: 20 }
    validates :updated_by, presence: false, length: { maximum: 20 }
end
