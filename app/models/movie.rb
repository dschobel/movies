require 'ruby-tmdb'

class Movie < ActiveRecord::Base
  attr_accessible :description, :director, :release_date, :title

  def self.search_tmdb title_search_term
      Tmdb.api_key = Settings.tmdb_api_key
      raise "missing tmdb_api_key configuration value in settings database" if Tmdb.api_key.nil?
      Tmdb.default_language =  Settings.tmdb_default_lang || Tmdb.default_language
      TmdbMovie.find(title: title_search_term, limit: Settings.tmdb_max_results)
  end
end
