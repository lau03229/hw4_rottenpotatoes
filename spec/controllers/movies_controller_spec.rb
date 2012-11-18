require 'spec_helper'

describe MoviesController do
	
  	describe 'searching TMDb' do

  		before :each do
  			@fake_results = [mock('movie1'), mock('movie2')]
  		end

	    it 'should call the model method that performs TMDb search' do

	    	Movie.should_receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
	    	post :search_tmdb, {:search_terms => 'hardware'}
	      
	    end

	    describe 'after valid search' do

	    	before :each do
	    		Movie.stub(:find_in_tmdb).and_return(@fake_results)
	    		post :search_tmdb, {:search_terms => 'hardware'}
	    	end

		    it 'should select the search results template for rendering' do
		    	response.should render_template('search_tmdb')
		    end

		    it 'should make the TMDb search results available to that template' do
		    	assigns(:movies).should == @fake_results
			end	

		end

  	end

  	describe 'searching for similar movies' do

	    context 'director is known' do
		
		    before :each do 
		      @fake_movies = [mock('Movie'), mock('Movie')]
		      @fake_movie = FactoryGirl.build(:movie, :id => "1", :title => "Star Wars", :director => "George Lucas") 
		      Movie.should_receive(:find_by_id).with("1").and_return(@fake_movie)
		      Movie.should_receive(:find_all_by_director).with(@fake_movie.director).and_return(@fake_movies)
		    end
		    
		    it 'should find the similar movies by director' do
		      get :search_similar, {:id => "1"}
		    end

		    it 'should select the Similiar Movies template for rendering' do
		      get :search_similar, {:id => "1"}
		      response.should render_template('search_similar')
		    end

		    it 'should make the results available to the template' do
		      get :search_similar, {:id => "1"}
		      assigns(:movies).should == @fake_movies
		     end

	  	end

    end

    
    describe 'searching for similar movies' do

    	context 'director is not known' do

    		before :each do 
				@fake_movie = FactoryGirl.build(:movie, :id => "1", :title => "Star Wars", :director => "") 
				Movie.stub(:find_by_id).with("1").and_return(@fake_movie)
				Movie.stub(:find_all_by_director).with(@fake_movie.director)
		    end

		    it 'should select the RottenPotatoes home page for rendering' do
		      get :search_similar, {:id => "1"}
		      response.should redirect_to(:controller => 'movies', :action => 'index')
		    end

		    it 'should display a message to the user that no director info was found' do
		      get :search_similar, {:id => "1"}
		      flash[:notice].should == ("'#{@fake_movie.title}' has no director info")
		    end

		end

    end

end
	