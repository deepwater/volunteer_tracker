class EventsService
  attr_reader :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @options = options
  end
  
  def create(attributes)
    factory = Factories::Event.new(@options)
    factory.create(attributes)
  end

  def update(id, attributes)
    factory = Factories::Event.new(@options)
    factory.update(id, attributes)
  end

end