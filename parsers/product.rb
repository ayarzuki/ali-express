html = Nokogiri.HTML(content)

# initialize empty hash
product = {}

# save the url
url = page['url']
product['url'] = url

# save the category
product['category'] = page['vars']['category']

# extract the product title
product['title'] = html.css('h1.product-title-text').text.strip

# extract product image
image_url = html.at_css('.images-view-item img')
product['image_url'] = image_url['src']

#extract discount price
discount = html.at_css('div.product-price-current')

if discount
    pricestring = discount.text.to_s
    price = pricestring.scan(/(\d+\.\d+)/)
    product['discount_low_price'] = price.first[0].to_f.to_s
    product['discount_high_price'] = price.last[0].to_f.to_s
else
    product['discount_price'] = price.to_f
end

# extract product rating
rating = html.at_css('.overview-rating-average')&.text
product['rating'] = rating.to_f if rating

# extract count review
reviews_count = html.at_css('span.product-reviewer-reviews')&.text
product['reviews_count'] = reviews_count.to_s if reviews_count

# extract total orders
order = html.at_css('span.product-reviewer-sold')&.text
product['order'] = order.to_s if order

# extract sizes
size_elem = html.css('ul.sku-property-list[2] li.sku-property-item')

if size_elem
    size = size_elem.css('div.sku-property-text').collect{|s| s.text.strip}
    product['size'] = size
end

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job's outputs
outputs << product