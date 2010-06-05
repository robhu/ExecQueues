require 'tasks'
require 'storage'
require 'logger'
Dir['task_types/*rb'].each{|file| require file}

#Storage.backend = MySQLBackend.new('mysql://root:password@localhost/commsdemo', :logger => Logger.new('worker.log'))
Storage.backend = RedisBackend.new(:host => 'localhost')

while true
  task = Storage.bget_new_and_make_inprogress
  
  # Create the 'interface'
  instance_eval("@interface = #{task.type}.new")

  # Get it to do whatever work it has to do
  #puts "Beginning: #{task.inspect}"
  task.output = @interface.execute(task.input)
  #puts "Finished: #{task.inspect}"
  #puts ""
  
  task.state = "finished"
  task.save
  
end