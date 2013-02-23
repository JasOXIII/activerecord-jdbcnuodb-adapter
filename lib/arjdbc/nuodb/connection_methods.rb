class ActiveRecord::Base
  class << self
    def nuodb_connection(config)
      config[:port] ||= 48004
      config[:schema] ||= config[:database]
      config[:url] ||= "jdbc:com.nuodb://#{config[:host]}:#{config[:port]}/#{config[:database]}?schema=#{config[:schema]}"
      config[:driver] ||= defined?(::Jdbc::NuoDB.driver_name) ? ::Jdbc::NuoDB.driver_name : 'com.nuodb.jdbc.Driver'
      config[:adapter_spec] ||= ::ArJdbc::NuoDB
      config[:adapter_class] = ActiveRecord::ConnectionAdapters::NuoDBAdapter
      config[:connection_alive_sql] ||= 'select 1 from system.tables fetch first 1 rows'
      jdbc_connection(config)
    end
  end
end
