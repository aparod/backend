EventMachine.next_tick do
  connection = AMQP.connect
  channel    = AMQP::Channel.new(connection)

  requests_queue = channel.queue("testqueue", :exclusive => false, :auto_delete => true)
  requests_queue.subscribe(:ack => true) do |metadata, payload|
    begin
      data = JSON.parse payload, :symbolize_names => true

      if data[:method_type] == 'instance'
        instance = data[:class_name].constantize.from_hash data[:object_state]

        ret = {
          :error => false,
          :data  => {
            :return_value => instance.send(data[:method_name], *data[:method_args]),
            :object_state => instance.attributes
          }
        }
      else
        ret = {
          :error => false,
          :data => data[:class_name].constantize.send(data[:method_name], *data[:method_args])
        }
      end

    rescue Exception => e
      ret = {
        :error => true,
        :data => e.message,
        :backtrace => e.backtrace
      }
    end

    puts "---"
    puts "Received: #{data.to_s}"
    puts "Sending: #{ret.to_s}"

    channel.default_exchange.publish(
      ret.to_json,
      :routing_key    => metadata.reply_to,
      :correlation_id => metadata.correlation_id,
      :immediate      => true,
      :mandatory      => true
    )

    metadata.ack
  end
end
