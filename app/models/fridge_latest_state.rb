class FridgeLatestState < ApplicationRecord
  belongs_to :fridge
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  validates :created_api_caller, presence: false, length: { maximum: 80 }
  validates :updated_api_caller, presence: false, length: { maximum: 80 }
end
