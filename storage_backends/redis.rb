require 'redis'

class RedisBackend
  def initialize(options)
    @redis = Redis.new(options)
  end
  
  def bget_new_and_make_inprogress
    task = Marshal.load(@redis.blpop("unstarted", 0)[1])
    task.state = "in_progress"
    task
  end
  
  def bget_finished_and_delete(task_id)
    task = Marshal.load(@redis.blpop("finished:#{task_id}", 0)[1])
    task
  end
  
  # This method returns the DB id of the saved task
  def save(task)
    task.id = @redis.incr('id_counter') if task.id.nil?
    @redis.lpush('unstarted', Marshal.dump(task)) if task.state == 'unstarted'
    @redis.lpush("finished:#{task.id}", Marshal.dump(task)) if task.state =='finished'
    task.id
  end
  
  
  # Utility methods
  def reset!
    @redis.keys('*').each{|key| @redis.del key}
  end
  
  def counter_incr(counter_name)
    @redis.incr(counter_name)
  end
end