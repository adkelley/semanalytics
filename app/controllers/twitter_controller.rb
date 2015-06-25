class TwitterController < ApplicationController
	def data
          #binding.pry
          #if current_user
	    if (params[:query])
	     t = Tapi.new
	     t.search(params[:query], 500, params[:min].to_i, params[:max].to_i)
	    else
	      t = Tapi.new
	      t.search("#tech", 500)
	    end
	    render :json => t.data
          # else
          #   flash[:error] = "Sorry, you must be logged in to search"
          #   redirect_to :back
          # end
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
