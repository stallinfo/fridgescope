class Facility < ApplicationRecord
  belongs_to :service
  has_many :fridges, dependent: :destroy
  has_many :facility_managers, dependent: :destroy
  validates :name, presence: false, length: { maximum: 60 }
  validates :created_by, presence: false, length: { maximum: 20 }
  validates :updated_by, presence: false, length: { maximum: 20 }
  validates :created_api_caller, presence: false, length: { maximum: 80 }
  validates :updated_api_caller, presence: false, length: { maximum: 80 }
end
