module Glass
  class Config


    attr_accessor :no_redis

    ##
    # Accepts:
    #   1. A 'hostname:port' String
    #   2. A 'hostname:port:db' String (to select the Redis db)
    #   3. A 'hostname:port/namespace' String (to set the Redis namespace)
    #   4. A Redis URL String 'redis://host:port'
    #   5. An instance of `Redis`, `Redis::Client`, `Redis::DistRedis`,
    #      or `Redis::Namespace`.
    def redis=(server)
      if @no_redis then return nil end
      return if server == "" or server.nil?

      @redis = case server
                 when String
                   if server['redis://']
                     redis = Redis.connect(:url => server, :thread_safe => true)
                   else
                     server, namespace = server.split('/', 2)
                     host, port, db = server.split(':')

                     redis = Redis.new(
                         :host => host,
                         :port => port,
                         :db => db,
                         :thread_safe => true
                     )
                   end
                   Redis::Namespace.new(namespace || :glass, :redis => redis)
                 when Redis::Namespace, Redis::Distributed
                   server
                 when Redis
                   Redis::Namespace.new(:glass, :redis => server)
               end
    end

    def redis
      if @no_redis then return nil end
      return @redis if @redis
      self.redis = Redis.respond_to?(:connect) ? Redis.connect : "localhost:6379"
      self.redis
    end

    def redis_id
      if @no_redis then return nil end
      # support 1.x versions of redis-rb
      if redis.respond_to?(:server)
        redis.server
      elsif redis.respond_to?(:nodes) # distributed
        redis.nodes.map(&:id).join(', ')
      else
        redis.client.id
      end
    end

    @no_redis


  end
end