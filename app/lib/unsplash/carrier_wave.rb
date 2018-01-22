module Unsplash::CarrierWave
  #https://images.unsplash.com/photo-1469406396016-013bfae5d83e?fm=jpg&auto=format&fit=crop&w=400&h=50&q=80
  #https://docs.imgix.com/apis/url/size/rect
  def self.included(base)
    base.storage Unsplash::CarrierWave::Storage
    base.extend ClassMethods

    override_in_versions(base, :blank?, :full_public_id, :my_public_id, :all_versions_processors, :stored_version)
  end

  def is_main_uploader?
    self.class.version_names.blank?
  end

  module ClassMethods
    # fit => photo where width or height scale
    # fit crop mode with the 600x400 dimensions, will generate a 600x398 image (scaling up the original image):
    def resize_to_fit(width, height)
      process :resize_to_fit => [width, height]
    end
    # fill - photo with exact dimensions specified
    def resize_to_fill(width, height, gravity="Center")
      process :resize_to_fill => [width, height, gravity]
    end

  end

  def set_or_yell(hash, attr, value)
    raise StandardError.new "conflicting transformation on #{attr} #{value}!=#{hash[attr]}" if hash[attr] && hash[attr] != value
    hash[attr] = value
  end

  def transformation
    return @transformation if @transformation
    @transformation = {}
    self.all_processors.each do |name, args, condition|
      if(condition)
        if condition.respond_to?(:call)
          next unless condition.call(self, :args => args)
        else
          next unless self.send(condition)
        end
      end
      case name
      when :resize_to_fit
        set_or_yell(@transformation, :w, args[0]) # width
        set_or_yell(@transformation, :h, args[1]) # height
        #fit = clip Resizes the image to fit within the width and height boundaries without cropping or distorting the image
        set_or_yell(@transformation, :fit, :clip)
      when :resize_to_fill
        set_or_yell(@transformation, :w, args[0])
        set_or_yell(@transformation, :h, args[1])
        set_or_yell(@transformation, :fit, :crop)
        set_or_yell(@transformation, :crop, :faces)
      when :unsplash_transformation
        args.each do
          |attr, value|
          set_or_yell(@transformation, attr, value)
        end
      else
        if args.blank?
          Array(send(name)).each do
            |attr, value|
            set_or_yell(@transformation, attr, value)
          end
        end
      end
    end
    @transformation
  end

  def all_versions_processors
    all_versions = self.class.instance_variable_get('@all_versions')

    all_versions ? all_versions.processors : []
  end

  def all_processors
    (self.is_main_uploader? ? [] : all_versions_processors) + self.class.processors
  end

  def add_photo(name)
    identifier = storage.store!(name)
    retrieve_from_store!(identifier)
  end

  def retrieve_from_store!(identifier)
    if identifier.blank?
      @file = @stored_version = @stored_public_id = nil
      self.original_filename = nil
    else
      @file = UnsplashFile.new(identifier, self)
      @public_id = @stored_public_id = @file.public_id
      @stored_version = @file.version
      self.original_filename = @file.filename
    end
  end

  def url(*args)
    if args.first && !args.first.is_a?(Hash)
      # request version
      super
    else
      # request normal url with not version
      options = args.extract_options!

      if self.blank?
        url = self.default_url
        return url if !url.blank?
        return nil
      else
        public_id = my_public_id
        #options[:version] ||= self.stored_version
      end
      options = self.transformation.merge(options) if self.version_name.present?

      unsplash_url(public_id, options)
    end
  end

  def unsplash_url(public_id, options = {})
    url_options = {
      fm: "jpg", # format of file
      auto: "format",
      q: 80 # quality
    }
    url_query = url_options.merge!(options).to_query

    "https://images.unsplash.com/#{public_id}?#{url_query}"
  end

  def public_id
    nil
  end

  def my_public_id
    @public_id ||= self.public_id
    @public_id ||= @stored_public_id
  end

  def stored_version
    @stored_version
  end

  def delete_dir!(path)
    false
  end

  def recreate_versions!
    # Do nothing
  end

  def cache_versions!(new_file=nil)
    # Do nothing
  end

  def process!(new_file=nil)
    # Do nothing
  end

  def delete_remote?
    false
  end

  # For the given methods - versions should call the main uploader method
  def self.override_in_versions(base, *methods)
    methods.each do
      |method|
      base.send :define_method, method do
        return super() if self.version_name.blank?
        uploader = self.model.send(self.mounted_as)
        uploader.send(method)
      end
    end
  end

  class UnsplashFile
    attr_reader :identifier, :public_id, :filename, :version
    def initialize(identifier, uploader)
      @uploader = uploader
      @identifier = identifier
      @filename = @identifier
      @version = nil
      @public_id = identifier
    end

    def storage_identifier
      identifier
    end

    def delete
      false
    end

    def exists?
      true
    end

  end

end