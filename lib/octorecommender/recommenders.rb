module Octo
  class Recommender

    # Queue for resque worker processing
    @queue = :recommender

    # Time format to convert a Time into HHMM format
    TIME_HHMM = '%H%M'

    # Initializes the Recommender.
    def initialize
    end


    # Register a user, action-time view relation.
    # @param [Octo::User] user The user object
    # @param [Time] ts The time at which user takes some action
    def register_user_action_time(user, ts = Time.now.floor)
      Octo::UserTime.new({
        userid: user.id,
        enterpriseid: user.enterprise.id,
        created_at: ts
      }).save
    end

    # Get recommended products for a user
    # @param [Octo::User] user The user object for whom product
    #   recommendations to be fetched
    # @return [Array<Octo::Product>] An array of Octo::Product recommended
    def recommended_products(user)
      eid = user.enterprise_id
      recommendations = Octo::ProductRecommendations.where({
        userid: user.id,
        enterpriseid: eid
      })
      recommendations.collect do |x|
        args = { enterprise_id: eid, id: x.product_id}
        Octo::Product.get_cached(args)
      end
    end

    # Get similar products for products
    # @param [Octo::Product] product The product for which similarities
    #   have to be found
    # @return [Array<Octo::Product>] An array containing similar
    #   products
    def similar_products(product, opts={})
      raise NotImplementedError
    end

    # Get recommended time for a user
    # @param [Octo::User] user The user for whom time to be fetched
    # @return [Array<Time>] The array of time recommended
    def recommended_time(user)
      eid = user.enterprise_id
      recommendations = Octo::TimeRecommendations.where({
        enterpriseid: eid,
        userid: user.id
      })
      recommendations.map do |r|
        r.next_times.map(Time.at)
      end
    end

    # Creates a delayed job to process all the recommenders for all the
    #   enterprises or can provide specific options as well
    def process!(opts = {})
      `Octo.get_config(:scripts)[:time_recommender_script]`
      `Octo.get_config(:scripts)[:product_recommender_script]`
    end

    # Callback method for resque worker
    def self.perform
      self.new.process!
    end

  end
end
