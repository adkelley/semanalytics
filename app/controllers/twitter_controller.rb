class TwitterController < ApplicationController
        @@max_word_count = 5
        @@min_word_count = 1

	def data
		if (params[:query])
	            #binding.pry
	            if params[:min]
	 				t = Tapi.new(params[:query], 1000, @@min_word_count)
	            else
	  				t = Tapi.new(params[:query], 1000)
	            end
		else
			t = Tapi.new("drugs", 500)
		end
		render :json => t.data
	end

        def threshold
            @@max_word_count ||= params[:max]
        end
        
	# def search
	# 	begin
	# 		t = Tapi.new
	# 		t.search(params[:query],500)
	# 		render :json => t.data
	# 	rescue RateLimitExceeded => e
	# 		@e = e
	# 		render :search
	# 	end
	# end
end
