# Wisper subscribers need to be refreshed here when we are in
# dev/test. This is due to code-reloading, which could re-subscribe
Rails.application.reloader.to_prepare do
  # existing handlers, leading to duplicates and errors
  Wisper.clear if Rails.env.development? || Rails.env.test?

  # https://niallburkley.com/blog/ruby-publish-subscribe/
  Wisper.subscribe(UserRequestSubscriber.new)
  Comment.subscribe(CommentSubscriber)
end
