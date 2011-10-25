class Task < ActiveRecord::Base

  validates :description, :presence => true

  validates :project_id, :presence => true

  belongs_to :project
end




# == Schema Information
#
# Table name: tasks
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  due_date    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  project_id  :integer(4)
#  completed   :boolean(1)
#

