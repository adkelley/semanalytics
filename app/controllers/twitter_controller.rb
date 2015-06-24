class TwitterController < ApplicationController
        @@max_word_count = 5
        @@min_word_count = 1

	def data
		if (params[:query])
			t = Tapi.new
                        #binding.pry
                        if params[:min]
			  t.search(params[:query], 500, @@max_word_count)
                        else
			  t.search(params[:query], 500)
                        end
		else
			t = Tapi.new
			t.search("#tech", 500)
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
