class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
  # validate_uniqueness_of :name
  # validate_length_of :name, minimum: 3, maximum: 25
  has_many :article_categories
  has_many :articles, through: :article_categories
end
