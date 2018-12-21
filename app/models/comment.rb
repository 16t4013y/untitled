class Comment < ApplicationRecord

  validates :message, presence: true, length: { maximum: 1000 }
  belongs_to :recruitment
  belongs_to :account

end
