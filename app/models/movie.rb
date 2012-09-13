class Movie < ActiveRecord::Base
  attr_accessible :description, :director, :release_date, :title
end
