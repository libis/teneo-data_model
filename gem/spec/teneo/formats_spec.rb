# frozen_string_literal: true

RSpec.describe 'Format Library' do
  it 'has list of formats' do
    fmt = Teneo::DataModel::Format['fmt/1']
    expect(fmt).not_to be nil
    expect(fmt.name).to eq('Broadcast WAVE')
    expect(fmt.version).to eq('0 Generic')
    expect(fmt.source).to eq('PRONOM')
  end

  it 'has tags attached to formats' do
    fmt = Teneo::DataModel::Format['fmt/114']
    expect(fmt.tags.size).to be >= 1
    expect(fmt.tags.map(&:tag)).to include('BMP')
  end

  it 'multiple formats can be tagged by the same tag' do
    tag = Teneo::DataModel::Tag['BMP']
    expect(tag.formats.size).to be >= 7
    expect(tag.formats.map(&:uid)).to include('fmt/114')
  end

  it 'tags can be tagged by other tags' do
    tag = Teneo::DataModel::Tag['BMP']
    expect(tag.parent_tags.size).to be >= 1
    expect(tag.parent_tags.map(&:tag)).to include('IMAGE')
  end

  it 'tagged tags can be found' do
    tag = Teneo::DataModel::Tag['IMAGE']
    expect(tag.all_child_tags.map(&:tag)).to include('BMP')
  end

  it 'formats can be resolved recursively' do
    tag = Teneo::DataModel::Tag['IMAGE']
    expect(tag.all_formats.map(&:uid)).to include('fmt/114')
  end
end
