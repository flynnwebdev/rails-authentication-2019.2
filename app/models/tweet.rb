class Tweet < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 5 }

  def can_edit?(user)
    return user == self.user || user.has_role?(:admin)
  end
end
