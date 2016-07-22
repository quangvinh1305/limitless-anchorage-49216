class Product < ActiveRecord::Base
  belongs_to :category
  has_many :line_items
  has_many :orders, through: :line_items
  belongs_to :user


  # searchable auto_index: false do
  #   text :description
  #   string :title
  #   string :pin
  # end
  # validates :title, :description, :image_url, presence: true
  # validates :price, numericality: {greater_than_or_equal_to: 0.01}
  #
  # validates :title, uniqueness: true

  # validates :title, length: {minimum: 10}
  mount_uploader :image, PictureUploader

  def self.newest_products
    Product.order(id: :desc).limit(5)
  end

  def decorate
    @decorate ||= ProductDecorator.new self
  end

  private

  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
end
