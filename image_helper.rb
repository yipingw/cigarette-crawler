require 'base64'
require 'open-uri'

class ImageHelper
  def ImageHelper.convert_image_to_base64(image_url)
    begin
      img = URI.open(image_url)
      puts 'opening this image...'
      result = Base64.strict_encode64(img.read)
      puts 'convert to base64 complete.'
      result
    rescue => error
      puts error.message
      puts 'retrying after 3 seconds for retrieve image from url...'
      sleep 3
      retry

    end

  end
end

