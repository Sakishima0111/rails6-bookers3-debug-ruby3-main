class Book < ApplicationRecord
  include Notifiable

  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :tag, presence:true

  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy   

  after_create do
    records = user.followers.map do |follower|
      notifications.new(user_id: follower.id)
    end 
    Notification.import records
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('name LIKE ?', '%' + content)
    else
      Book.where('name LIKE ?', '%' + content + '%')
    end
  end 


  def notification_message
    "フォローしている#{user.name}さんが#{title}を投稿しました"
  end

  def notification_path
    book_path(self)
  end

end
