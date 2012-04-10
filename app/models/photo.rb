class Photo < ActiveRecord::Base
  belongs_to :gallery
  has_attached_file :image, :styles => { :large => "700x700>", :medium => "300x300>", :thumb => "100x100>" }
end
