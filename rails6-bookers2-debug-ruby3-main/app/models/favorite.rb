class Favorite < ApplicationRecord
  include Notifiable
  after_create do
    create_notification(user_id: book.user_id)
  end

  belongs_to :user
  belongs_to :book
  validates_uniqueness_of :book_id, scope: :user_id
  has_one :notification, as: :notifiable, dependent: :destroy
  
  def notification_message
    "投稿した#{book.title}が#{user.name}さんにいいねされました"
  end

  def notification_path
     user_path(user)
  end

end
