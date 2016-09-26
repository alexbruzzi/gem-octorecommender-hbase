require 'octocore-hbase'

require 'octorecommender/recommenders'
require 'octorecommender/version'
require 'octorecommender/octohooks'
require 'octorecommender/scheduler'

module Octo

  def self.connect(configuration)
    self._connect(configuration)
  end

end
