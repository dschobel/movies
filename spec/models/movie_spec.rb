require 'spec_helper'

describe Movie do
    describe ".search_tmdb" do
        it "should reflect the api key in the Settings table" do
            Settings.stub(:tmdb_api_key).once.and_return "foo"
            TmdbMovie.stub(:find)
            Movie.search_tmdb "inception"
            Tmdb.api_key.should == "foo"
        end

        it "should reflect the default language in the Settings table" do
            Settings.stub(:tmdb_default_lang).once.and_return "bar"
            Settings.stub(:tmdb_api_key).once.and_return "foo"
            TmdbMovie.stub(:find)
            Movie.search_tmdb "inception"
            Tmdb.default_language.should be == "bar"
        end
        it "should pass search_term and max_limit to search method" do
            Settings.stub(:tmdb_api_key).once.and_return "foo"
            Settings.stub(:tmdb_max_results).once.and_return 321
            TmdbMovie.stub(:find)
            TmdbMovie.should_receive(:find).with({title: "inception", limit: 321})
            Movie.search_tmdb "inception"
        end


        it "should assign a default_language of en if the setting is missing" do
            Tmdb.stub(:default_language).and_return "a default"
            Settings.stub(:tmdb_api_key).once.and_return "foo"
            Settings.stub(:tmdb_default_lang).once.and_return nil
            TmdbMovie.stub(:find)
            Movie.search_tmdb "inception"
            Tmdb.default_language.should be == "a default"
        end

        it "should return Tmdb.Movie.find's results" do
            m = FactoryGirl.build :movie
            Settings.stub(:tmdb_api_key).once.and_return "foo"
            TmdbMovie.stub(:find).once.and_return [m]
            Movie.search_tmdb("inception").should == [m]
        end
    end
end
