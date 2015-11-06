class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy
    has_many :relationships, foreign_key: "follower_id", dependent: :destroy
    has_many :followed_users, through: :relationships, source: :followed
    before_save { email.downcase! }
    before_create :create_remember_token
    #before_create :create_slug

	  validates :name,  presence: true, length: { maximum: 50 }
	  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    VALID_SLUG_REGEX = /\w/i
    validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

    validates :slug, presence:   true,
                     format:     { with: VALID_SLUG_REGEX },
                     uniqueness: { case_sensitive: false },
                     length:     { maximum: 15 }
    
    has_secure_password
    validates :password, length: { minimum: 6 }

    has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
    has_many :followers, through: :reverse_relationships, source: :follower

    def User.new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def feed
      Micropost.from_users_followed_by(self)
    end

    def following?(other_user)
      relationships.find_by(followed_id: other_user.id)
    end

    def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
      relationships.find_by(followed_id: other_user.id).destroy!
    end

    def to_param
        "#{slug}".downcase # как выводить в URL
    end    

    private

      

    #def create_slug
      # если в модели определено поле slug, slug задаётся вручную
      #self.slug = self.email.downcase
      # если поле slug не определено, генерируется автоматически
      # исходя из значения поля title (заголовок статьи)
      # self.slug=self.title.parameterize
    #end

      def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
      end
end
