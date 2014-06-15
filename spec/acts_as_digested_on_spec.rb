require 'spec_helper'

class Article < ActiveRecord::Base
  define_table do |t|
    t.integer :user_id
    t.string :title
    t.text :url
    t.string :digest
    t.string :my_digest
    t.text :content
  end
end

describe ActsAsDigestedOn do
  before do
    Article.reset_callbacks :validate
    Article.destroy_all
  end

  before do
    @url = 'http://example.com'
  end

  it 'has a version number' do
    expect(ActsAsDigestedOn::VERSION).not_to be nil
  end

  describe '#generate_digest' do
    it 'should generate sha-1 digest of target field with some string' do
      Article.acts_as_digested_on :url

      article = Article.new(url: @url)
      expect(article.generate_digest).to eq(
        Digest::SHA1.hexdigest("--#{ @url }--"))
    end

    describe 'when more than one target field is given' do
      it 'should generate sha-1 digest of target fields with some string' do
        Article.acts_as_digested_on [:title, :url]

        title = 'an article'
        article = Article.new(title: title, url: @url)
        expect(article.generate_digest).to eq(
          Digest::SHA1.hexdigest("--#{ title }--#{ @url }--"))
      end
    end
  end

  describe 'before validation' do
    it 'should set "digest" field' do
      Article.acts_as_digested_on :url

      article = Article.new(url: @url)
      expect(article.digest).to be_nil
      article.valid?
      expect(article.digest).to eq article.generate_digest
    end

    it 'should set the digest value to :digest_column field when :digest_column option is set' do
      Article.acts_as_digested_on :url, digest_column: :my_digest

      article = Article.new(url: @url)
      expect(article.digest).to be_nil
      expect(article.my_digest).to be_nil

      article.valid?
      expect(article.digest).to be_nil
      expect(article.my_digest).to eq article.generate_digest
    end
  end

  describe 'when validation' do
    it 'should validate uniqueness of digest field by default' do
      Article.acts_as_digested_on :url

      Article.create! url: @url
      expect {
        Article.create! url: @url
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect {
        Article.create! url: 'http://example2.com'
      }.not_to raise_error
    end

    it 'should carry over the options to the validates_uniqueness_of options' do
      Article.acts_as_digested_on :url, scope: :user_id

      Article.create! url: @url, user_id: 1
      expect {
        Article.create! url: @url, user_id: 1
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect {
        Article.create! url: @url, user_id: 2
      }.not_to raise_error
      expect {
        Article.create! url: 'http://example2.com', user_id: 1
      }.not_to raise_error
    end

    it 'should validate uniqueness of digest field when :unique option is true' do
      Article.acts_as_digested_on :url, unique: true

      Article.create! url: @url
      expect {
        Article.create! url: @url
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect {
        Article.create! url: 'http://example2.com'
      }.not_to raise_error
    end

    it 'should not validate uniqueness of digest field when :unique option is false' do
      Article.acts_as_digested_on :url, unique: false

      Article.create! url: @url
      expect { Article.create! url: @url }.not_to raise_error
    end

    it 'should support string key options' do
      Article.acts_as_digested_on :url, 'unique' => false

      Article.create! url: @url
      expect { Article.create! url: @url }.not_to raise_error
    end
  end
end
