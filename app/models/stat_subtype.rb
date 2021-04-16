class StatSubtype < ApplicationRecord
  belongs_to :stat_type
  has_many :stats
end
