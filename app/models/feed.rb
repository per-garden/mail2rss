class Feed < ApplicationRecord
  has_many :messages, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  # Name sensibly usable as part of URL
  validates :name, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  # A feed must allow at least one message
  validates :count, :numericality => { greater_than_or_equal_to: 1 }
  serialize :senders
  serialize :subjects
  serialize :bodies
end
