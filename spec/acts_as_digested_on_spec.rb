require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Article < ActiveRecord::Base
  define_table do |t|
    t.string :title
    t.text :url
    t.string :digest
    t.string :my_digest
    t.text :content
  end
end

describe "ActsAsDigestedOn" do
  describe '#generate_digest' do
    it 'should generate sha-1 digest of target field with some string' do
      Article.class_eval do
        acts_as_digested_on :url
      end

      url = 'http://example.com'
      article = Article.new(:url => url)
      article.generate_digest.should == Digest::SHA1.hexdigest("--#{ url }--")
    end

    describe 'when more than one target field is given' do
      it 'should generate sha-1 digest of target fields with some string' do
        Article.class_eval do
          acts_as_digested_on [:title, :url]
        end

        title = 'an article'
        url = 'http://example.com'
        article = Article.new(:title => title, :url => url)
        article.generate_digest.should == Digest::SHA1.hexdigest("--#{ title }--#{ url }--")
      end
    end
  end

  describe 'before validation' do
    it 'should set "digest" field' do
      Article.class_eval do
        acts_as_digested_on :url
      end

      url = 'http://example.com'
      article = Article.new(:url => url)
      article.digest.should be_nil
      article.valid?
      article.digest.should == article.generate_digest
    end

    it 'should set the digest value to :digest_column field when :digest_column option is set' do
      pending
    end
  end

  describe 'when validation' do
    it 'should validate uniqueness of digest field by default' do
      pending
    end

    it 'should validate uniqueness of digest field when :unique option is true' do
      pending
    end

    it 'should carry over the options to the validates_uniqueness_of options' do
      pending
    end

    it 'should not validate uniqueness of digest field when :unique option is false' do
      pending
    end
  end
end
