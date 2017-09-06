module Genability
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, raw=false, unformatted=false)
      request(:get, path, options, raw, unformatted)
    end

    # Perform an HTTP POST request
    def post(path, options={}, raw=false, unformatted=false)
      request(:post, path, options, raw, unformatted)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, raw=false, unformatted=false)
      request(:put, path, options, raw, unformatted)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, raw=false, unformatted=false)
      request(:delete, path, options, raw, unformatted)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, raw=false, unformatted=false)
      response = connection(raw).send(method) do |request|
        path = formatted_path(path) unless unformatted || default_request?
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          if options['fileData']
            request.headers['Content-type'] = 'multipart/form-data'
            request.body = options
          else
            request.headers['Content-Type'] = 'application/json;charset=utf-8'
            if !options.empty?
              request.body = options.is_a?(Hash) ? options.to_json : options
            end
          end
        end
      end
      if raw
        response
      elsif response && response.body && !response.body.is_a?(String)
        response.body
      else
        raise Genability::InvalidResponseFormat, "Invalid response format: #{response && response.body}"
      end
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end

    def default_request?
      format.to_sym == :json
    end
  end
end

