require 'nokogiri'
require 'open-uri'
require './image_helper'
require './ocr'
require './db'

class Resolver
  @@doc = nil
  def Resolver.crawl_cigarette_attributes(cigarette_id)
    begin
      @@doc = Nokogiri::HTML(URI.open("https://www.yanyue.cn/product/#{cigarette_id}"))
    rescue => error
      puts error.message
      puts 'retrying after 3 seconds for open product webpage...'
      retry
    end

    return if @@doc.css('ul.ul_1 > li').size == 0

    cigarette = nil
    arr = []
    att = {}

    @@doc.css('ul.ul_1 > li').each do |link|
      if link.attributes['class'].value == 'info_title'
        att[:att_name] = link.content
      else
        if link.attributes['class'].value == 'info_content' && nil == link.first_element_child
          att[:att_val] = link.content
        end
        if link.attributes['class'].value == 'info_content' && nil != link.first_element_child && link.first_element_child.node_name != 'img'
          att[:att_val] = link.content
        end
        if link.attributes['class'].value == 'info_content' && nil != link.first_element_child && link.first_element_child.node_name == 'img'
          image_url = link.child.attributes['src'].value
          base64_string = ImageHelper.convert_image_to_base64(image_url)
          ocr_result = OCR.image_to_literal(base64_string)
          att[:att_val] = ocr_result["words_result"][0]["words"]
        end

        if link.attributes['class'].value == 'info_content' && nil != link.first_element_child && link.first_element_child.node_name == 'span'
          image_url = link.child.child.attributes['src'].value
          base64_string = ImageHelper.convert_image_to_base64(image_url)
          ocr_result = OCR.image_to_literal(base64_string)
          att[:att_val] = ocr_result["words_result"][0]["words"]
        end

        arr << att
        att = {}
      end
    end

    cigarette = {cigarette_id: cigarette_id.to_i, cigarette_attributes: arr}
    Db.stock(cigarette)
    p cigarette
  end
end
