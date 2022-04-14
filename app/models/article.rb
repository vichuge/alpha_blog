class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  # belongs_to :user
  # has_many :comments, dependent: :destroy
  # validates :title, presence: true, length: { minimum: 5 }
  # validates :text, presence: true, length: { minimum: 10 }

  has_many :article_categories
  has_many :categories, through: :article_categories
end

# article.save
# article.errors.full_messages
