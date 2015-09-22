class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.uniq.pluck(:rating).sort
  end
end
