class Fridge < ApplicationRecord
  belongs_to :facility
  has_many :fridge_past_states, dependent: :destroy
  has_many :fridge_last_states, dependent: :destroy
  validates :name, presence: false, length: { maximum: 60 }
  validates :description, presence: false, length: { maximum: 200 }
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  validates :created_api_caller, presence: false, length: { maximum: 80 }
  validates :updated_api_caller, presence: false, length: { maximum: 80 }
end
