require 'spec_helper'

describe MoviesController do

  #m = FactoryGirl.build(:movie)
  def valid_attributes
    {title: "Inception", director: "Christopher Nolan", release_date: "7-16-2010", description: "In a world where technology exists to enter the human mind through dream invasion, a highly skilled thief is given a final chance at redemption which involves executing his toughest job to date: Inception."}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MoviesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  def invalid_search 
      post :search_tmdb,{},valid_session
  end

  def valid_search(search_term="")
     post :search_tmdb,{search_terms: search_term},valid_session
  end

  describe "POST search_tmdb" do
      describe "with valid params" do
          it "should call search_tmdb of Movie model" do
              Movie.stub(:search_tmdb).and_return []
              Movie.should_receive(:search_tmdb).once.with 'inception'
              valid_search "inception"
          end

          describe "and there are results" do
              it "should assign results to search_results" do
                  m = FactoryGirl.create(:movie)
                  Movie.stub(:search_tmdb).and_return { [m] }
                  valid_search
                  expect(assigns(:search_results)).to eq([m])
              end

              it "should render the search_tmdb template" do
                  m = FactoryGirl.create(:movie)
                  Movie.stub(:search_tmdb).and_return { [m] }
                  valid_search
                  response.should render_template(:search_tmdb)
              end

              it "should limit the number of results to the first 10" do
                  m = FactoryGirl.create(:movie)
                  Movie.stub(:search_tmdb).and_return { [m]*20 }
                  valid_search
                  expect(assigns(:search_results)).to eq([m]*10)
              end
          end

          describe "when no results are returned" do
              it "should render new movie template" do
                  Movie.stub(:search_tmdb).and_return { [] }
                  valid_search
                  response.should render_template('new')
              end

              it "should have an error message in flash.now" do
                  Movie.stub(:search_tmdb).and_return { [] }
                  valid_search
                  flash.now[:error].should_not be_nil
              end
          end
      end

      describe "with invalid params" do
          it "should render new movie template" do
              invalid_search
              response.should render_template('new')
          end

          it "should have an error message in flash.now" do
              invalid_search
              flash.now[:error].should_not be_nil
          end
      end
  end

  describe "GET index" do
    it "assigns all movies as @movies" do
      movie = Movie.create! valid_attributes
      get :index, {}, valid_session
      assigns(:movies).should eq([movie])
    end
  end

  describe "GET show" do
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :show, {:id => movie.to_param}, valid_session
      assigns(:movie).should eq(movie)
    end
  end

  describe "GET new" do
    it "assigns a new movie as @movie" do
      get :new, {}, valid_session
      assigns(:movie).should be_a_new(Movie)
    end
  end

  describe "GET edit" do
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :edit, {:id => movie.to_param}, valid_session
      assigns(:movie).should eq(movie)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Movie" do
        expect {
          post :create, {:movie => valid_attributes}, valid_session
        }.to change(Movie, :count).by(1)
      end

      it "assigns a newly created movie as @movie" do
        post :create, {:movie => valid_attributes}, valid_session
        assigns(:movie).should be_a(Movie)
        assigns(:movie).should be_persisted
      end

      it "redirects to the created movie" do
        post :create, {:movie => valid_attributes}, valid_session
        response.should redirect_to(Movie.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved movie as @movie" do
        # Trigger the behavior that occurs when invalid params are submitted
        Movie.any_instance.stub(:save).and_return(false)
        post :create, {:movie => {}}, valid_session
        assigns(:movie).should be_a_new(Movie)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Movie.any_instance.stub(:save).and_return(false)
        post :create, {:movie => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested movie" do
        movie = Movie.create! valid_attributes
        # Assuming there are no other movies in the database, this
        # specifies that the Movie created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Movie.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => movie.to_param, :movie => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested movie as @movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        assigns(:movie).should eq(movie)
      end

      it "redirects to the movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        response.should redirect_to(movie)
      end
    end

    describe "with invalid params" do
      it "assigns the movie as @movie" do
        movie = Movie.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Movie.any_instance.stub(:save).and_return(false)
        put :update, {:id => movie.to_param, :movie => {}}, valid_session
        assigns(:movie).should eq(movie)
      end

      it "re-renders the 'edit' template" do
        movie = Movie.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Movie.any_instance.stub(:save).and_return(false)
        put :update, {:id => movie.to_param, :movie => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested movie" do
      movie = Movie.create! valid_attributes
      expect {
        delete :destroy, {:id => movie.to_param}, valid_session
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      movie = Movie.create! valid_attributes
      delete :destroy, {:id => movie.to_param}, valid_session
      response.should redirect_to(movies_url)
    end
  end

end
