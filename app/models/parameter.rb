class Parameter < ActiveRecord::Base
  belongs_to :settings
  belongs_to :user
end
