require 'cache/active_support_cache_store'
module Cache::ActiveSupportCacheNullStore
  def self.extended(base)
    base.extend Cache::ActiveSupportCacheStore
  end

  def _stats
    {}
  end
end