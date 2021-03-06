class DiyComment < ApplicationRecord
  belongs_to :diy
  belongs_to :customer

  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
end
