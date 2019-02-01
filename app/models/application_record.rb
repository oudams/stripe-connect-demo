class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def resource; end
end
