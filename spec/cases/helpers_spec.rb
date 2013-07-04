require "helper"

feature 'Assets change detection' do
  scenario 'with an assets digest enabled' do
    visit('/')
    page.should have_xpath("//head/meta[@name='assets-digest']", :visible => false)
  end
end