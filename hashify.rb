require 'open-uri'
require 'byebug'

def parse_www_encoded_form(www_encoded_form)
  query_str = URI::decode_www_form(www_encoded_form)
  #[['user[address][street]','main'],['user[address][zip]','89436']]
  query_str.map! { |key, val| [parse_key(key), val] }
  
  hash_merger(query_str)
end

# this should return an array
# user[address][street] should return ['user', 'address', 'street']
def parse_key(key)
  key.split(/\]\[|\[|\]/)
end

# pass this array of 2-element arrays:
# each el looks like: [['user', 'address', 'street'], 'main']
def hash_merger(query_vals)#another hash that is nested)
  merged_hash = Hash.new
  # for each key_val_set
  # check if key exists in merged_hash
  #   if not - add in the value
  #   if yes - key into merged_hash with key, and check next key

  query_vals.each do |keys, val|
    current = merged_hash
    keys.each_with_index do |key,i|
      if i == keys.length - 1
        current[key] = val
      else
        current[key] ||= {}
        current = current[key]
      end
      
    end
  end
  
  
  merged_hash
end

puts 'Should be: { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }'
p parse_www_encoded_form("user[address][street]=main&user[address][zip]=89436")

