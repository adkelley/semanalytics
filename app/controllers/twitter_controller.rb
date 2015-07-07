require "Tapi"

class TwitterController < ApplicationController
	
	# fix indentation
	# add tests
	def data
	    if (params[:query])
	    	
             if logged_in?
               current_user.queries.create(query_properties)
             end
             
	     t = Tapi.new(params[:query], 1000, params[:min].to_i, params[:max].to_i)
            else
	      t = Tapi.new("#tech", 500,4,5000)
	    end
	    
	    render :json => t.data

	end
private 

   def query_properties
       query = {}
       query[:query_string] = params[:query]
       query[:word_count_min] = params[:min].to_i
       query[:word_count_max] = params[:max].to_i	
   end
end
