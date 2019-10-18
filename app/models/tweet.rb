class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def can_edit?(user)
    return user == self.user || user.has_role?(:admin)
  end
end
