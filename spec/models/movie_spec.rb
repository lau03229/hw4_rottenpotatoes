 require 'spec_helper'

 describe Movie do

 	describe 'searching TMDb by keyword' do

 		context 'with valid key' do

			it 'should call TMDb with valid keywords' do

				TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception')
				Movie.find_in_tmdb('Inception')

			end 			

 		end

 		context 'with invalid key' do

 			it 'should raise InvalidKeyError if key not given' do

 				Movie.stub(:api_key).and_return('')
 				lambda { Movie.find_in_tmdb('Inception') }.should raise_error(Movie::InvalidKeyError)

 			end

 			it 'should raise error InvalidKeyError if key is bad' do

 				TmdbMovie.stub(:find).and_raise(RuntimeError.new('API returned status code 404'))
 				lambda { Movie.find_in_tmdb('Inception') }.should raise_error(Movie::InvalidKeyError)

 			end

 		end

 	end

 end
