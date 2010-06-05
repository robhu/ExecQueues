require 'rubygems'
require 'redis'

redis = Redis.new(:host => 'localhost')

while true
  puts "Done: #{redis.get('jobs_done')} in the last second"
  redis.set('jobs_done', 0)
  sleep 1
end