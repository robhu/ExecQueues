require 'tasks'
require 'storage'
require 'logger'

#Storage.backend = MySQLBackend.new('mysql://root:password@localhost/commsdemo', :logger => Logger.new('client.log'))
#Storage.backend = MySQLBackend.new('mysql://root:password@localhost/commsdemo')
Storage.backend = RedisBackend.new(:host => 'localhost')
#Storage.reset!

#task = Task.new(:type => 'DoSomethingSlowly', :input => rand(1000))
#task.save
#puts Storage.bget_finished_and_delete(task.id).inspect




start_time = Time.now
num_done = 0

while true
  task = Task.new(:type => 'CalculateMultipleOfPi', :input => rand(1000))
  #task = Task.new(:type => 'DoSomethingSlowly', :input => rand(1000))
  task.save
  puts "[#{Time.now}] Submitted: #{task.inspect}"
  puts "[#{Time.now}] Received:  #{Storage.bget_finished_and_delete(task.id).inspect}"
  puts ""
  
  Storage.counter_incr('jobs_done')
end