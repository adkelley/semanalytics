class TwitterController < ApplicationController
	def search
		begin
			t = Tapi.new
			t.search(params[:query],500)
			render :json => t.data
		rescue RateLimitExceeded => e
			@e = e
			render :search
		end
	end
end
