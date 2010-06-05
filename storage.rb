require 'rubygems'
require 'sequel'
Dir['storage_backends/*.rb'].each{|f| require f}

class Storage
  # Get the type of storage backend (MySQL, Redis, ...)
  def self.backend
    @backend
  end
  
  # Set the storage backend (MySQL, Redis, ...)
  def self.backend=(backend)
    @backend = backend
  end
  
  # Save a task
  def self.save(task)
    @backend.save(task)
  end
  
  # Get a task and mark it as being 'in progress'
  def self.bget_new_and_make_inprogress
    @backend.bget_new_and_make_inprogress
  end
  
  # Get specific task by ID and delete it
  def self.bget_finished_and_delete(task_id)
    @backend.bget_finished_and_delete(task_id)
  end
  
  # Clear the data store
  def self.reset!
    @backend.reset!
  end
  
  # Increase a counter (used to track performance)
  def self.counter_incr(counter_name)
    @backend.counter_incr(counter_name)
  end
end