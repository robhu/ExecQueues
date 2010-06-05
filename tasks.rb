class Task
  attr_accessor :id
  attr_accessor :input
  attr_accessor :output
  attr_accessor :state
  attr_accessor :type
  
  attr_accessor :lock_version
  
  def initialize(options = {})
    @state = 'unstarted'
    options.each{|k,v| instance_variable_set("@#{k}", v)}
  end
  
  def save
    task_id = Storage.save(self)
    @id = task_id
  end
end
