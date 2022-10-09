KAFKA_PRODUCER = WaterDrop::Producer.new

KAFKA_PRODUCER.setup do |config|
  config.deliver = true
  config.kafka = { 'bootstrap.servers': 'localhost:9092' }
end
