rm *.gem
gem build octorecommender-hbase.gemspec && gem uninstall octorecommender-hbase --force && gem install octorecommender-hbase-0.0.6.gem
