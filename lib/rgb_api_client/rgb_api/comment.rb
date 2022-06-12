class Comment < RGBAPI
  attr_reader :id, :post, :content

  def self.new(**args)
    comment = allocate
    args[:post].add_comment(comment)
    comment.send(:initialize, **args)
    comment
  end

  def initialize(**args)
    @id = args[:id]
    @post = args[:post]
    @content = args[:content]
  end

  def create()
    body = { Content: @content }.to_json
    response = RGBClient.post "/api/posts/#{@post.id}/comments", body
    res_body = parse_body(response)
    log_and_raise(response: response, msg: "Failed to create post comment.") if response.status != 200 or res_body["msg"] != "Post comment created successfully."
    @id = res_body["data"]["ID"]
    return self
  end
end
