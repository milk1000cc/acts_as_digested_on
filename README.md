# ActsAsDigestedOn [![Build Status](https://travis-ci.org/milk1000cc/acts_as_digested_on.svg)](https://travis-ci.org/milk1000cc/acts_as_digested_on)

acts_as_digested_on is a gem for Rails 3 and Rails 4.

This sets the digested value before validation and validates uniqueness of the digested value.

If you use this gem for Rails 2, see rails-2 branch.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_digested_on'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_digested_on

## Usage

```ruby
# db/migrate/20090706000000_create_articles.rb
class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.text :url       # any type is ok
      t.string :digest  # this is sha-1 hex digest field of url value
      ...
    end

    add_index :articles, :digest, :unique => true  # you can add index on digest field
  end

  def self.down
    drop_table :articles
  end
end

# app/models/article.rb
class Article < ActiveRecord::Base
  acts_as_digested_on :url  # please add this
  ...
end

# this means
class Article < ActiveRecord::Base
  validates_uniqueness_of :digest
  before_validation :set_digest

  def generate_digest
    Digest::SHA1.hexdigest "--#{ url.to_s }--"
  end

  private
  def set_digest
    self.digest = generate_digest
  end
  ...
end
```

## Examples

```ruby
acts_as_digested_on :url, :unique => false

acts_as_digested_on :url, :digest_column => :url_digest

acts_as_digested_on [:url, :salt]

acts_as_digested_on :url, :scope => :site_id

Article.new(:url => 'http://example.com').generate_digest
```

## Contributing

1. Fork it ( https://github.com/milk1000cc/acts_as_digested_on/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
