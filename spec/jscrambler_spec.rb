require 'spec_helper'

ACCESS_KEY = ENV['JSCRAMBLER_ACCESS_KEY']
SECRET_KEY = ENV['JSCRAMBLER_SECRET_KEY']

describe Jscrambler do
  describe "upload_code" do
    before(:each) do
      @created = Jscrambler.new(ACCESS_KEY, SECRET_KEY).upload_code(['spec/sample/sample.js'],{})
      sleep(5)
    end

    it "should response with project id" do
      expect(@created['id']).not_to eq(nil)
    end

    after(:each) do
      Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
    end
    
  end

  describe "get_information" do
    it "should response 200"
    it "should response with project id"
    it "should response with error id"
    it "should response with error message"
  end

  describe "download_code" do
    it "should response 200"
    it "should zip file"
    
  end

  describe "delete_code" do
    before(:each) do
      @created = Jscrambler.new(ACCESS_KEY, SECRET_KEY).upload_code(['spec/sample/sample.js'],{})
      sleep(5)
    end

    it "should response with project id" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
      expect(response['id']).to eq(@created['id'])
    end
    
    it "should response with deleted flag" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
      expect(response['deleted']).to eq('true')
    end
  end
end
