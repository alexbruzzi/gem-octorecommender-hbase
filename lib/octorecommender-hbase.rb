require 'octocore-hbase'

require 'octorecommender-hbase/recommenders'
require 'octorecommender-hbase/version'
require 'octorecommender-hbase/octohooks'
require 'octorecommender-hbase/scheduler'

module Octo

  def self.connect(configuration)
    self._connect(configuration)
  end

end
