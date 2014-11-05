require 'open-uri'


module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      if req.query_string.nil?
        @params = {}
      else
        @params = parse_www_encoded_form(req.query_string)
      end
      unless req.body.nil?
        @params.merge!parse_www_encoded_form(req.body)
      end
      @params.merge!(route_params)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    
    def hash_body(request)
      
    end
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

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
  end
end
