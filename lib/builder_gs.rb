require "builder_gs/version"

module BuilderGs
  PROTOCOL = 'http';
  AMAZON_ENDPOINT = 'https://amazon-product-reviews-keywords.p.rapidapi.com';

  def contact_api path, parameters, required_options
    options = {
        method: 'get',
        error_handler: true,
        response_key: 'data'
    }
    options.merge!(required_options)
    protocol = (options[:subsystem] == 'amazon') ? 'https' : PROTOCOL
    conn = prepare_conn path, parameters, options[:subsystem], protocol
    key = options[:response_key]

    api_response = make_api_request conn, options, path, parameters

    json_response = JSON.parse api_response.body if api_response.body.include? '{'
  
    if key == :fetch_api_response
      api_response
    elsif key == :fetch_json_response_body
      json_response 
    elsif key != :no_key
      json_response[key]
    end
  end

  def make_api_request conn, options, path, parameters
    api_response = conn.send(options[:method]) do |req|
      req.headers['Content-Type'] = 'application/json'
      if (options[:subsystem].present? && options[:subsystem] == 'amazon')
        req.headers['X-RapidAPI-Key'] = '680bb37899msh2e19126da068080p150ca0jsn1f17f6760f9b'
        req.headers['X-RapidAPI-Host'] = 'amazon-product-reviews-keywords.p.rapidapi.com'
      else  
        req.headers['secret-key'] = ''
        req.headers['access-token'] = options[:access_token] if options[:access_token].present?
        req.headers['secret-token'] = options[:secret_token] if options[:secret_token].present?
      end

      if parameters.present?
        if options[:method].in? ['put', 'post', 'delete', 'patch']
          req.body = parameters
        elsif options[:method].in? ['get']
          req.params = JSON.parse(parameters) rescue parameters
        end
      end
    end
    api_response
  end

  def amazon_ep
    AMAZON_ENDPOINT
  end

  def prepare_conn path, parameters, subsystem = nil, protocol = PROTOCOL
    endpoint = (self.send((subsystem.downcase + '_ep').to_sym))
    url = endpoint.start_with?('http://', 'https://') ? "#{endpoint}/#{path}" : "#{protocol}://#{endpoint}/#{path}"
    url = URI.encode url
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
    
    response = conn.get do |req|
      req.headers['X-RapidAPI-Key'] = '680bb37899msh2e19126da068080p150ca0jsn1f17f6760f9b'
      req.headers['X-RapidAPI-Host'] = 'amazon-product-reviews-keywords.p.rapidapi.com'
    end
    conn
  end

  def error response
    
    if response.status != 200
      return { json: JSON.parse(response.body), status: response.status }
    end
    response
  end
end
