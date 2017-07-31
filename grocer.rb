def consolidate_cart(cart)
  result = {}

    cart.each do |elements|
      elements.each do |keys, values|

        if !result[keys]
          result[keys] = values
          result[keys][:count] = 1
        elsif result[keys]
          result[keys][:count] += 1
        end

      end
    end

  result
end



def apply_coupons(cart, coupons)
  result = {}

  cart.each do |elements, keys|
    coupons.each do |coupon|

      if elements == coupon[:item] && keys[:count] >= coupon[:num]
        keys[:count] = keys[:count] - coupon[:num]

        if result["#{elements} W/COUPON"]
          result["#{elements} W/COUPON"][:count] += 1
        else
          result["#{elements} W/COUPON"] = {
            price: coupon[:cost],
            clearance: keys[:clearance],
            count: 1
          }
        end

      end

    end
    result[elements] = keys
  end

  result
end



def apply_clearance(cart)
  result = {}

  cart.each do |elements, keys|
    result[elements] = {}

    if keys[:clearance] == true
      result[elements][:price] = keys[:price] * 4/5
    else
      result[elements][:price] = keys[:price]
    end

    result[elements][:clearance] = keys[:clearance]
    result[elements][:count] = keys[:count]
  end

  return result
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  result = 0

  cart.each do |elements, keys|
    result += (keys[:price] * keys[:count])
  end

  result > 100 ? result * 0.9 : result
end
