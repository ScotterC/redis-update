#!/usr/bin/ruby

#    Copyright (c) 2012, Scott Carleton
#    http://scottcarleton.com
#
#    Permission is hereby granted, free of charge, to any person obtaining a
#    copy of this software and associated documentation files (the "Software"),
#    to deal in the Software without restriction, including without limitation
#    the rights to use, copy, modify, merge, publish, distribute, sublicense,
#    and/or sell copies of the Software, and to permit persons to whom the
#    Software is furnished to do so, subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be included
#    in all copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'rubygems'
require 'redis'

class RedisUpdater

  def initialize(redis, pattern)
    @redis = redis
    @keys = Hash.new
    @pattern = pattern
    @dbsize = 0
  end

  def update_keys
    puts "Getting a list of all keys..."
    keys = @redis.keys(@pattern)
    puts "Updating keys..."
    keys.each_with_index do |key, index|
      update_key(key)
    end
  end

  def update_key(key)
    pipeline = @redis.pipelined do
      @redis.debug("object", key)
      @redis.type(key)
      @redis.ttl(key)
    end
    puts "updating #{key}"
    if pipeline[2] == -1
      @redis.expire key, 86400
    end
  rescue Redis::CommandError
    $stderr.puts "Skipping key #{key}"
  end

end

if ARGV.length < 3 || ARGV.length > 4
  puts "Usage: redis-update.rb <host> <port> <dbnum> <(optional)pattern>"
  exit 1
end

host = ARGV[0]
port = ARGV[1].to_i
db = ARGV[2].to_i
pattern = ARGV[3].to_s

redis = Redis.new(:host => host, :port => port, :db => db)
updater = RedisUpdater.new(redis, pattern)
puts "Updating #{host}:#{port} db:#{db} pattern #{pattern} keys"
updater.update_keys
