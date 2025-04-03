# frozen_string_literal: true

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Loading Format tags ...'

    Teneo::DataModel::Tag.from_yaml_file(file: File.join(File.dirname(__FILE__), '..', 'data', 'tags', 'teneo_tags.yml'),
                                         key: :tag) do |tag|
      tag.profile = 'teneo'
    end
  end
end
