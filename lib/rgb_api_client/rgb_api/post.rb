class Post < RGBAPI
  attr_reader :id, :title, :content, :comments

  def initialize(**args)
    @id = args[:id]
    @title = args[:title]
    @content = args[:content]
    @comments = []
  end

  def add_comment(comment)
    @comments.push(comment)
  end

  def create()
    body = { Title: @title, Content: @content }.to_json
    response = post "/api/posts", body
    res_body = parse_body(response)
    log_and_raise(response: response, msg: "Failed to create post.") if response.status != 200 or res_body["msg"] != "Post created successfully."
    @id = res_body["data"]["ID"]
    return self
  end

  def destroy()
    response = delete "/api/posts/#{@id}"
    res_body = parse_body(response)
    log_and_raise(response: response, msg: "Failed to delete post.") if response.status != 200 or res_body["msg"] != "Post deleted successfully."
    @id = nil
  end

  def fetch_comments()
    response = get "/api/posts/#{@id}/comments"
    res_body = parse_body(response)
    log_and_raise(response: response, msg: "Failed to list post comments.") if response.status != 200 or res_body["msg"] != "Post comments fetched successfully."
    @comments = res_body["data"].map { |comment| Comment.new post: self, id: comment["ID"], content: comment["Content"] }
  end
end
