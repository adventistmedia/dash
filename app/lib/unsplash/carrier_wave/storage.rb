class Unsplash::CarrierWave::Storage < ::CarrierWave::Storage::Abstract

  def identifier
    uploader.file.respond_to?(:storage_identifier) ? uploader.file.storage_identifier : super
  end

  # get identifier as is or from url write attribute
  def store!(filename)
    if name = filename[/photo\-[a-zA-Z0-9\-]+/]
      store_unsplash_identifier(name)
      name
    end
  end

  def store_unsplash_identifier(name)
    model_class = uploader.model.class
    column = uploader.model.send(:_mounter, uploader.mounted_as).send(:serialization_column)
    uploader.model.send :write_attribute, column, name
  end

end