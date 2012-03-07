require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

describe "ActsAsDigestedOn" do
  before do
    Article.reset_callbacks :validate
    Article.destroy_all
  end

  before do
    @url = 'http://example.com'
  end

  describe '#generate_digest' do
    it 'should generate sha-1 digest of target field with some string' do
      Article.acts_as_digested_on :url

      article = Article.new(:url => @url)
      article.generate_digest.should == Digest::SHA1.hexdigest("--#{ @url }--")
    end

    describe 'when more than one target field is given' do
      it 'should generate sha-1 digest of target fields with some string' do
        Article.acts_as_digested_on [:title, :url]

        title = 'an article'
        article = Article.new(:title => title, :url => @url)
        article.generate_digest.should == Digest::SHA1.hexdigest("--#{ title }--#{ @url }--")
      end
    end
  end

  describe 'before validation' do
    it 'should set "digest" field' do
      Article.acts_as_digested_on :url

      article = Article.new(:url => @url)
      article.digest.should be_nil
      article.valid?
      article.digest.should == article.generate_digest
    end

    it 'should set the digest value to :digest_column field when :digest_column option is set' do
      Article.acts_as_digested_on :url, :digest_column => :my_digest

      article = Article.new(:url => @url)
      article.digest.should be_nil
      article.my_digest.should be_nil
      article.valid?
      article.digest.should be_nil
      article.my_digest.should == article.generate_digest
    end
  end

  describe 'when validation' do
    it 'should validate uniqueness of digest field by default' do
      Article.acts_as_digested_on :url

      Article.create! :url => @url
      proc { Article.create!(:url => @url) }.should raise_error(ActiveRecord::RecordInvalid)
      proc { Article.create!(:url => 'http://example2.com') }.should_not raise_error
    end

    it 'should carry over the options to the validates_uniqueness_of options' do
      Article.acts_as_digested_on :url, :scope => :user_id

      Article.create! :url => @url, :user_id => 1
      proc { Article.create!(:url => @url, :user_id => 1) }.should raise_error(ActiveRecord::RecordInvalid)
      proc { Article.create!(:url => @url, :user_id => 2) }.should_not raise_error
      proc { Article.create!(:url => 'http://example2.com', :user_id => 1) }.should_not raise_error
    end

    it 'should validate uniqueness of digest field when :unique option is true' do
      Article.acts_as_digested_on :url, :unique => true

      Article.create! :url => @url
      proc { Article.create!(:url => @url) }.should raise_error(ActiveRecord::RecordInvalid)
      proc { Article.create!(:url => 'http://example2.com') }.should_not raise_error
    end

    it 'should not validate uniqueness of digest field when :unique option is false' do
      Article.acts_as_digested_on :url, :unique => false

      Article.create! :url => @url
      proc { Article.create!(:url => @url) }.should_not raise_error
    end

    it 'should support string key options' do
      Article.acts_as_digested_on :url, 'unique' => false

      Article.create! :url => @url
      proc { Article.create!(:url => @url) }.should_not raise_error
    end
  end
end
