class Project < ActiveRecord::Base

  validates :name, :presence => true

  validates :user_id, :presence => true

  belongs_to :user
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer(4)
#

