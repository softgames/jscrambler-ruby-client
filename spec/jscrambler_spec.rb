require 'spec_helper'

ACCESS_KEY = ENV['JSCRAMBLER_ACCESS_KEY']
SECRET_KEY = ENV['JSCRAMBLER_SECRET_KEY']

describe Jscrambler do
  describe "upload_code" do
    before(:each) do
      @created = Jscrambler.new(ACCESS_KEY, SECRET_KEY).upload_code(['spec/sample/sample.js'],{})
      sleep(5)
    end

    after(:each) do
      Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
    end

    it "should response with project id" do
      expect(@created['id']).not_to eq(nil)
    end
    
  end

  describe "get_information" do
    before(:each) do
      @created = Jscrambler.new(ACCESS_KEY, SECRET_KEY).upload_code(['spec/sample/sample.js'],{})
      sleep(5)
    end

    after(:each) do
      Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
    end

    it "should response with project id" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).get_information(@created['id'])
      expect(response['id']).not_to eq(nil)
    end

    it "should response with error id" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).get_information(@created['id'])
      expect(response['error_id']).to eq(0.to_s)
    end

    it "should response with error message" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).get_information(@created['id'])
      expect(response['error_message']).to eq("OK")
    end
  end

  describe "download_code" do
    
    before(:each) do
      @created = Jscrambler.new(ACCESS_KEY, SECRET_KEY).upload_code(['spec/sample/sample.js'],{})
      sleep(5)
    end
    
    after(:each) do
      Jscrambler.new(ACCESS_KEY, SECRET_KEY).delete_code(@created['id'])
    end
    
    it "should response zip file" do
      response = Jscrambler.new(ACCESS_KEY, SECRET_KEY).download_code(@created['id'])
      expect(response).not_to eq(nil)
    end
    
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
