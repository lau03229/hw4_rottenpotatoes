FactoryGirl.define do

	factory :movie do

		title 'A fake title' # default values
		rating 'PG'
		release_date { 10.years.ago }
		director ''

	end

end