class MySQLBackend
  def initialize(connection_url, options = {})
    @db = Sequel.connect(connection_url, options)
    @tasks = @db[:tasks]
  end
  
  def bget_new_and_make_inprogress
    task = nil
    while task.nil?
      task_from_db = @tasks.filter(:state => 'unstarted').first

      if task_from_db
        task = Task.new(task_from_db)
        
        # Optimistic locking
        rows_updated = @tasks.filter(:state => 'unstarted', :id => task.id, :lock_version => task.lock_version).update(:state => 'in_progress', :lock_version => task.lock_version+1)
        
        # If the row was updated by another client the lock_version differs so there are no updates so set to nil to say failed
        task = nil if rows_updated == 0
      else
        sleep 0.005
      end
    end
    
    task
  end
  
  def bget_finished_and_delete(task_id)
    task = nil
    while task.nil?
      task_from_db = @tasks.filter(:state => 'finished', :id => task_id).first
      
      if task_from_db
        task = Task.new(task_from_db)
        @tasks.filter(:state => 'finished', :id => task_id).delete
      else
        sleep 0.001
      end
    end
    
    task
  end
  
  # This method returns the DB id of the saved task
  def save(task)
    if task.id
      @tasks.filter(:id => task.id).update(:input => task.input, :output => task.output, :state => task.state, :type => task.type)
    else
      @tasks.insert(:input => task.input, :output => task.output, :state => task.state, :type => task.type)
    end
  end
  
  def reset!
    @tasks.all.delete
  end
  
  
  # We need to use Redis to store the performance information
  require 'redis'
  @redis = Redis.new
  
  def counter_incr(counter_name)
    @redis.incr(counter_name)
  end
end