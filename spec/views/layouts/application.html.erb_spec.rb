require 'spec_helper'

describe 'layouts/application.html.erb' do 
	it 'should render a sidebar partial' do
		render
		rendered.should match('<div class="sidebar-nav">')
	end
	it 'should render a header partial' do
		render
		rendered.should match('<header class="navbar navbar-fixed-top navbar-inverse">')
	end
	it 'should render a modal' do 
		render
		rendered.should match('<div class="modal fade" id="about-modal-window" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">')
	end
	
end