class FridgeLatestState < ApplicationRecord
  belongs_to :fridge
  has_one_attached :current_picture_path
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  validates :created_api_caller, presence: false, length: { maximum: 80 }
  validates :updated_api_caller, presence: false, length: { maximum: 80 }
end
