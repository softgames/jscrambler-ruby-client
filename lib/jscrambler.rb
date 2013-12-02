require 'base64'
require 'openssl'
require 'uri'
require 'rest-client'
require 'json'

class Jscrambler

  API_URL = 'http://api.jscrambler.com/v3'

  def initialize(access_key, secret_key)
    @access_key = access_key
    @secret_key = secret_key

    @files_content = nil
    @files_md5 = nil
  end

  def upload_code(files, params)
    action = '/code.json'

    prepare_files_data(files)

    query_params = {}
    #add default params
    query_params['timestamp']  = Time.now.utc.iso8601.to_s
    query_params['access_key'] = @access_key
    query_params['signature'] = generate_signature('POST', action, query_params.merge(@files_md5))
    
    request = RestClient::Request.new(
                                      :method => :post,
                                      :url => "#{API_URL}#{action}",
                                      :payload => {
                                                   :multipart => true                                                     
                                                  }.merge(query_params).merge(@files_content).merge(params)
                                     )

    JSON.parse(request.execute)
  end

  def get_information(project_id)
    action = "/code/#{project_id}.json"

    query_params = {}
    #add default params
    query_params['timestamp']  = Time.now.utc.iso8601.to_s
    query_params['access_key'] = @access_key
    query_params['signature'] = generate_signature('GET', action, query_params)

    request = RestClient::Request.new(
                                      :method => :get,
                                      :url => "#{API_URL}#{action}?#{query_string(query_params)}"
                                     )

    JSON.parse(request.execute)
  end

  def download_code
  end

  def delete_code(project_id)
    action = "/code/#{project_id}.zip"

    query_params = {}
    #add default params
    query_params['timestamp']  = Time.now.utc.iso8601.to_s
    query_params['access_key'] = @access_key
    query_params['signature'] = generate_signature('DELETE', action, query_params)

    request = RestClient::Request.new(
                                      :method => :delete,
                                      :url => "#{API_URL}#{action}?#{query_string(query_params)}"
                                     )

    JSON.parse(request.execute)
  end

  private
    
  def generate_signature(request_method, resource_path, params)
    Base64.strict_encode64(OpenSSL::HMAC.digest(
                                                OpenSSL::Digest::SHA256.new, 
                                                @secret_key, 
                                                "#{request_method};#{api_hostname};#{resource_path};#{query_string(params)}"
                                               )
                          )
  end

  def api_hostname
    URI(API_URL).hostname
  end

  def query_string(params)
    items = []
    params.keys.sort.each do |key|
      items.push("#{key}=#{url_encode(params[key])}")
    end

    items.join('&')
  end

  def url_encode(string)
    str = CGI::escape(string)
    str = str.sub('%7E', '~')
    str = str.sub('+', '%20')
  end

  def prepare_files_data(files)
    @files_md5 = {}
    @files_content = {}
    files.each do |file|
      @files_md5["file_#{@files_md5.size}"] = Digest::MD5.hexdigest(File.read(file))
      @files_content["file_#{@files_content.size}"] = File.new(file, 'rb')
    end
  end
  
end
