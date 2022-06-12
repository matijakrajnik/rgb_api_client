module RGBClient
  extend self

  TIMEOUT = 60
  HEADERS = {
    "Accept-Encoding" => "gzip, deflate, br",
    "User-Agent" => "RGB API Client",
    "Content-Type" => "application/json;charset=UTF-8",
    "Accept" => "application/json, text/plain, */*",
    "Connection" => "keep-alive",
  }

  class AuthorizationError < Exception; end
  class RGBAPIError < Exception; end

  def init(url:, log_file: "rgb_api_client.log")
    @@base_url = url
    @@client = HTTPClient.new(default_header: HEADERS)
    @@client.send_timeout = TIMEOUT

    @@logger = Logger.new(log_file)
    @@logger.level = :debug

    HttpLog.configure { |config|
      config.logger = @@logger
    }

    return self
  end

  def get(path, body = nil, header = {})
    @@client.get @@base_url + path, body, header
  end

  def post(path, body = nil, header = {})
    @@client.post @@base_url + path, body, header
  end

  def put(path, body = nil, header = {})
    @@client.put @@base_url + path, body, header
  end

  def delete(path, body = nil, header = {})
    @@client.delete @@base_url + path, body, header
  end

  def authorize(username:, password:)
    body = { Username: username, Password: password }.to_json
    response = post "/api/signin", body

    raise AuthorizationError.new if response.status != 200

    res_body = parse_body(response)

    log_and_raise(response: response, msg: "Authorization failed.") if res_body["msg"] != "Signed in successfully." or res_body["jwt"].nil? or res_body["jwt"] == ""

    @@jwt = res_body["jwt"]
    @@client.default_header.merge!({ "Authorization" => "Bearer #{@@jwt}" })

    return self
  end

  def parse_body(response)
    JSON.parse response.body
  end

  def log_response(response)
    @@logger.error {
      "Status code: #{response.status}. " +
      "Headers:\n#{response.headers}. " +
      "Body:\n#{parse_body(response)}"
    }
  end

  def log_and_raise(response:, msg:)
    log_response(response)
    raise RGBAPIError.new(msg)
  end
end
