require 'elasticsearch'

unless ENV['ELASTICSEARCH_URL'].to_s.empty?
  puts "Connecting to Elasticsearch..."
  client = Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], transport_options: {
    headers: {
      'Authorization': "Bearer #{ENV['ELASTICSEARCH_ACCESS_TOKEN']}"
    }
  }

  Jekyll::Hooks.register :posts, :post_render do |post|
    puts "Indexing #{post.url}..."
    client.index index: 'models', id: post.url, body: {
      title: post.data['title'],
      task: post.data['task'],
      language: post.data['language'],
      edition: post.data['edition'],
      date: post.data['date'].strftime('%F')
    }
  end
end
