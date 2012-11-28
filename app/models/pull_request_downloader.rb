class PullRequestDownloader
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def pull_requests
    @pull_requests ||= download_pull_requests
  end

  private
  def github_client
    @github_client ||= Octokit::Client.new(:login => user.nickname, :oauth_token => user.token, :auto_traversal => true)
  end

  def download_pull_requests
    events = github_client.user_events(user.nickname)
    events.select{|e| e.type == 'PullRequestEvent' && e.payload.action == 'opened' }
  end
end