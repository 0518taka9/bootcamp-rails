class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, message: 'Too short to post' }
  validates :body, presence: true
  validates :author, presence: true

  # PV数を+1
  def redis_access
    REDIS.zincrby 'posts', 1, id
  end

  # PV数が多い5記事を取得
  def self.most_popular(limit: 5)
    most_popular_ids =
        REDIS.zrevrangebyscore 'posts', '+inf', 0, limit: [0, limit]
    where(id: most_popular_ids).sort_by do |post|
      most_popular_ids.index(post.id.to_s)
    end
  end

  # PV数を取得
  def redis_page_view
    REDIS.zscore('posts', id).floor
  end
end
