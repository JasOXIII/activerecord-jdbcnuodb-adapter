require 'spec_helper'
require 'active_record'
require 'active_record/connection_adapters/jdbcnuodb_adapter'

describe ActiveRecord::ConnectionAdapters::NuoDBAdapter do
  before do
  end

  after do
  end

  context 'using transactions' do

    before(:each) do
    end

    after(:each) do
    end

    it 'is supported by the driver' do
      lambda {
        ActiveRecord::Base.establish_connection(
            :adapter => 'nuodb',
            :database => 'test',
            :username => 'cloud',
            :password => 'user'
        )

        ActiveRecord::Schema.define do
          drop_table :tracks if self.table_exists?('tracks')
          drop_table :albums if self.table_exists?('albums')
        end

        ActiveRecord::Schema.define do
          create_table :albums do |table|
            table.column :title, :string
            table.column :performer, :string
          end

          create_table :tracks do |table|
            table.column :album_id, :integer
            table.column :track_number, :integer
            table.column :title, :string
          end
        end

        class Album < ActiveRecord::Base
          has_many :tracks
        end

        class Track < ActiveRecord::Base
          belongs_to :album
        end

        Album.transaction do
          album = Album.create(:title => 'Black and Blue', :performer => 'The Rolling Stones')
          album.tracks.create(:track_number => 1, :title => 'Hot Stuff')
          album.tracks.create(:track_number => 2, :title => 'Hand Of Fate')
          album.tracks.create(:track_number => 3, :title => 'Cherry Oh Baby ')
          album.tracks.create(:track_number => 4, :title => 'Memory Motel ')
          album.tracks.create(:track_number => 5, :title => 'Hey Negrita')
          album.tracks.create(:track_number => 6, :title => 'Fool To Cry')
          album.tracks.create(:track_number => 7, :title => 'Crazy Mama')
          album.tracks.create(:track_number => 8, :title => 'Melody (Inspiration By Billy Preston)')
        end

      }.should_not raise_error
    end

  end
end