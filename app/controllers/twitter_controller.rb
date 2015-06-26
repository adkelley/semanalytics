class TwitterController < ApplicationController
  include SessionsHelper
  require "./lib/Tapi.rb"

	def data

          #binding.pry
          #if current_user
	    if (params[:query])
             user = current_user
             if user
               query_params = {}
               query_params[:query_string] = params[:query]
               query_params[:word_count_min] = params[:min].to_i
               query_params[:word_count_max] = params[:max].to_i
               new_query = Query.new(query_params)
               user.queries << new_query
             end
	     t = Tapi.new(params[:query], 1000, params[:min].to_i, params[:max].to_i)
            else
	      t = Tapi.new("#tech", 500,4,5000)
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
