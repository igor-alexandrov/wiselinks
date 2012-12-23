require 'helper'

class ApplicationControllerTest < ActionController::TestCase
  tests ApplicationController
 
  context "Request" do 
    setup do
      @request = @controller.request
    end

    should "respond to #wiselinks?" do
      assert_respond_to @request, :wiselinks?
    end
    
    should "respond to #wiselinks_partial?" do
      assert_respond_to @request, :wiselinks_partial?
    end    
    
    should "respond to #wiselinks_template?" do
      assert_respond_to @request, :wiselinks_template?
    end
  end

  context "Layout" do
    should "respond to #wiselinks_layout" do
      assert_respond_to @controller, :wiselinks_layout
    end
  end

  context "Title" do
    should "respond to #wiselinks_title" do
      assert_respond_to @controller, :wiselinks_title
    end
  end
end