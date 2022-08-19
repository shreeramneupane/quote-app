class Quote < ApplicationRecord
  validates_presence_of :title

  def self.random
    order("RANDOM()").first
  end
end
