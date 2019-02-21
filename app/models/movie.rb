class Movie < ActiveRecord::Base
    # creating enumerable collection of all possible ratings
    def self.all_ratings
      result = {}
      
      # selecting each unique rating
  	  self.select(:rating).uniq.each do |movie|
  		result[movie.rating] = 1
	  end
	  
  	  return result
    end
end
