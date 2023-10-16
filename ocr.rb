require 'uri'
require 'net/http'
require 'json'
require 'cgi'

class OCR

  ACCESS_KEY = 'xxxxxxxxxxxxxx'
  SECRET_KEY = 'xxxxxxxxxxxxxxx'
  GRANT_TYPE = 'client_credentials'

  def OCR.image_to_literal(base64_string)



    uri = URI('https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic')
    uri.query = URI.encode_www_form({
                                      'access_token' => 'xxxxxxxxxx'
                                    })
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = "image=base64,#{CGI.escape base64_string}"



    begin
      response = https.request(request)
      res_json = JSON.parse(response.read_body)
      if res_json['error_code'] == 18
        raise res_json['error_msg']
      else
        res_json
      end
    rescue => error
      puts "#{error.message} #{request.body}"
      puts 'retrying after 5 seconds for ocr service...'
      sleep 5
      retry
    end
  end

  private

  def get_access_token
    uri = URI('https://aip.baidubce.com/oauth/2.0/token')
    uri.query = URI.encode_www_form({
                                      'client_id' => ACCESS_KEY,
                                      'client_secret' => SECRET_KEY,
                                      'grant_type' => GRANT_TYPE
                                    })
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json;charset=UTF-8'

    begin
      res_json = JSON.parse(https.request(request).read_body)
      if res_json['error_code'] == 'invalid_client'
        raise res_json['error_msg']
      else
        res_json['access_token']
      end
    end
  end
end
