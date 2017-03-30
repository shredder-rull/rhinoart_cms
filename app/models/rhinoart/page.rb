module Rhinoart
  class Page < Rhinoart::ApplicationRecord

    paginates_per 30

    module TYPE
      PAGE = :page
      BLOG = :blog
      ARTICLE = :article
      TESTIMONIAL = :testimonial
    end

    TYPES = [TYPE::PAGE, TYPE::BLOG, TYPE::ARTICLE, TYPE::TESTIMONIAL]
    VALID_SLUG_REGEX = /\A[-_.\/A-Za-z0-9А-Яа-я]+\z/i

    default_scope { order(:lft) }
    scope :active, ->{ where(active: true) }
    scope :ready, ->{ active.where('published_at <= ?', Time.current) }

    before_validation :name_to_slug
    before_validation :set_published_at

    has_many :contents, -> { order 'position' }, class_name: 'Rhinoart::PageContent', dependent: :destroy#, inverse_of: :page
    accepts_nested_attributes_for :contents, allow_destroy: true

    has_many :fields, class_name: 'Rhinoart::PageField', dependent: :destroy

    accepts_nested_attributes_for :fields, allow_destroy: true

    has_many :page_comments, -> { order 'id' }, autosave: true, dependent: :destroy, inverse_of: :page

    accepts_nested_attributes_for :page_comments, allow_destroy: true

    has_many :relations, as: :relation, inverse_of: :page

    belongs_to :user, class_name: Rhinoart.config.user_class, required: false

    scope :articles, ->{ where(type: TYPE::ARTICLE) }
    scope :published, ->{ where('published_at > ?', Time.current)}

    serialize :images, JSON

    before_save do
      self.images = contents.flat_map{|c| Nokogiri::HTML.parse(c.content).xpath('//img/@src').map(&:value)  }.uniq
    end

    # Validations
    validates :name, :published_at, presence: true
    validates :slug, presence: true, if: ->{ name.present? }
    validates :name, length: { maximum: 255 }
    validates :slug, length: { maximum: 255 }, allow_blank: true
    validates :slug, uniqueness: { case_sensitive: false, scope: :parent_id }, allow_blank: true
    validates :slug, format: { with: VALID_SLUG_REGEX }, allow_blank: true

    acts_as_nested_set dependent: :destroy, touch: true

    has_paper_trail

    def content(name='main_content')
      contents.find_by(name: name).try(:content) || ''
    end

    def content=(content)
      return if content.nil?
      contents.find_or_initialize_by(name: 'main_content').content = content
    end

    def field(name)
      fields.find_by(name: name.downcase).try(:value)
    end

    def self.index
      self.find_by!(slug: 'index')
    end

    def self.blog
      self.find_or_create_by!(name: 'Blog') do |blog|
        next if blog.persisted?
        blog.type = TYPE::BLOG
        blog.contents.build(name: 'main_content', content: 'This content is not using')
      end
    end

    def title
      field(:title).try(:presence) || name
    end

    protected

    def should_generate_new_friendly_id?
      false
    end

    def set_published_at
      self.published_at ||= Time.current
    end

    def name_to_slug
      slug = name.to_s.parameterize
      self.slug = ( (parent.present? and parent.active?) ? ( parent.slug + "/" + slug ) : slug ) if self.slug.blank?
    end

  end
end
