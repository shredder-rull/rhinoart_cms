# == Schema Information
#
# Table name: rhinoart_settings
#
#  id    :integer          not null, primary key
#  name  :string(120)      default(""), not null
#  value :text
#  descr :text
#

module Rhinoart
	class Setting < Rhinoart::ApplicationRecord
		default_scope { order 'name' }

		validates :name, uniqueness: { case_sensitive: false }, format: { :with => /\A[-_a-zA-Z0-9]+\z/ }
		validates :name, :length => { :in => 2..150 }
		# validates :value
		has_paper_trail

		after_save do
			self.class.new(name: name).cache_method_clear(:get)
		end

		def name=(name)
			self[:name] = name.try(:downcase)
		end

		def get(default_value = nil)
			self.class.find_by(name: name).try(:value) || default_value
		end

		def as_cache_key
			['setting', name]
		end

		cache_method :get, 1.day

		def self.get(name, default_value = nil)
			new(name: name).get(default_value)
		end

	end
end