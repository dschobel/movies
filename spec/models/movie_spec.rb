require 'spec_helper'

describe Movie do
    describe ".search_tmdb" do
        describe "if the api key is missing or invalid" do
            it "should raise an error if the api key is nil" do
                Settings.stub(:tmdb_api_key).once.and_return nil
                TmdbMovie.stub(:find)
                expect {Movie.search_tmdb "inception"}.to raise_error(RuntimeError)
            end
            it "should raise an error if the api key is an empty string" do
                Settings.stub(:tmdb_api_key).once.and_return ""
                expect {Movie.search_tmdb "inception"}.to raise_error(ArgumentError)
            end
            it "should raise an error if the api key is invalid" do
                Settings.stub(:tmdb_api_key).once.and_return "invalid key"
                TmdbMovie.stub(:find).once.and_raise(RuntimeError)
                expect {Movie.search_tmdb "inception"}.to raise_error(RuntimeError)
            end
        end
        describe "the api key is present and valid" do
            it "should reflect the api key in the Settings table" do
                Settings.stub(:tmdb_api_key).once.and_return "foo"
                TmdbMovie.stub(:find)
                Movie.search_tmdb "inception"
                expect(Tmdb.api_key).to eq "foo"
            end

            it "should reflect the default language in the Settings table" do
                Settings.stub(:tmdb_default_lang).once.and_return "bar"
                Settings.stub(:tmdb_api_key).once.and_return "foo"
                TmdbMovie.stub(:find)
                Movie.search_tmdb "inception"
                expect(Tmdb.default_language).to eq "bar"
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
                expect(Tmdb.default_language).to eq "a default"
            end

            it "should return Tmdb.Movie.find's results" do
                m = FactoryGirl.build :movie
                Settings.stub(:tmdb_api_key).once.and_return "foo"
                TmdbMovie.stub(:find).once.and_return [m]
                expect(Movie.search_tmdb("inception")).to eq [m]
            end
        end
    end
end
