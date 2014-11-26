require "rubygems"
require "stringex"
require 'rake'
require 'yaml'
require 'time'

source_dir = "."
posts_dir = "_posts"
new_post_ext = "markdown"

SOURCE = "."
CONFIG = {
    'layouts' => File.join(SOURCE, "_layouts"),
    'posts' => File.join(SOURCE, "_posts"),
    'post_ext' => "md",
}

# Usage: rake post title="A Title" [date="2012-02-09"] [tags=[tag1, tag2]]
desc "Begin a new post in #{CONFIG['posts']}"
task :post do
    abort("rake aborted: '#{CONFIG['posts']}' directory not found.") unless FileTest.directory?(CONFIG['posts'])
    title = ENV["title"] || "new-post"
    tags = ENV["tags"] || "[]"
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    begin
        date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
    rescue => e
        puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
        exit -1
    end
    filename = File.join(CONFIG['posts'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
    if File.exist?(filename)
        abort("rake aborted! #{filename} already exists. You can't overwrite it!!!")
    end

    puts "Creating new post: #{filename}"
    open(filename, 'w') do |post|
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/-/,' ')}\""
        post.puts "tags: []"
        post.puts 'description: ""'
        post.puts "category: "
        post.puts "comment: true"
        post.puts "date: #{Time.now.localtime.strftime('%Y-%m-%d %H:%M')}"
        post.puts "---"
    end
end # task :post


# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
    raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
    mkdir_p "#{source_dir}/#{posts_dir}"
    args.with_defaults(:title => 'new-post')
    title = args.title
    filename = "#{source_dir}/#{posts_dir}/#{Time.now.localtime.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
    if File.exist?(filename)
        abort("rake aborted! #{filename} already exists. You can't overwrite it!!!")
    end
    puts "Creating new post: #{filename}"
    open(filename, 'w') do |post|
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
        post.puts "tags: []"
#       post.puts "meta: true"
        post.puts "comment: true"
        post.puts "date: #{Time.now.localtime.strftime('%Y-%m-%d %H:%M')}"
        post.puts "---"
    end
end
