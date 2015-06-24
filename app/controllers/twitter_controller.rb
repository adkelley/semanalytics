class TwitterController < ApplicationController
	def data
		if (params[:query])
			t = Tapi.new
                        #binding.pry
			t.search(params[:query], 500, params[:min].to_i)
		else
			t = Tapi.new
			t.search("#tech", 500)
		end
		render :json => t.data
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
