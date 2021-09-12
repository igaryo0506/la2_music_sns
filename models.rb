require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :posts
    has_many :favorites
    has_many :favorite_posts, through: :favorites , source: :post
    
    has_many :following_relationships, class_name: 'Relationship', foreign_key: :followed_id
    has_many :followed_relationships, class_name: 'Relationship', foreign_key: :following_id
    has_many :follows, through: 'followed_relationships', source: 'followed'
    has_many :followers, through: 'following_relationships', source: 'following'
end

class Post < ActiveRecord::Base
    belongs_to :user
    has_many :favorites
    has_many :favorite_users, through: :favorites ,source: :user
end

class Favorite < ActiveRecord::Base
    belongs_to :post
    belongs_to :user
end

class Relationship < ActiveRecord::Base
    belongs_to :following, class_name: 'User'
    belongs_to :followed, class_name: 'User'
end