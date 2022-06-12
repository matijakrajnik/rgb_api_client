class RGBAPI
  include RGBClient

  def fetch_posts()
    response = get "/api/posts"
    res_body = parse_body(response)
    log_and_raise(response: response, msg: "Failed to list user posts.") if response.status != 200 or res_body["msg"] != "Posts fetched successfully."
    res_body["data"].map { |post| Post.new id: post["ID"], title: post["Title"], content: post["Content"] }
  end
end
