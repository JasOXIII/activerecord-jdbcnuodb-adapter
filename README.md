# ActiveRecord JDBC NuoDB Adapter 

[<img
src="https://api.travis-ci.org/nuodb/activerecord-jdbcnuodb-adapter.png?branch
=master" alt="Build Status"
/>](http://travis-ci.org/nuodb/activerecord-jdbcnuodb-adapter) [<img
src="https://gemnasium.com/nuodb/activerecord-jdbcnuodb-adapter.png?travis"
alt="Dependency Status"
/>](https://gemnasium.com/nuodb/activerecord-jdbcnuodb-adapter) [<img
src="https://codeclimate.com/github/nuodb/activerecord-jdbcnuodb-adapter.png"
/>](https://codeclimate.com/github/nuodb/activerecord-jdbcnuodb-adapter)

## DESCRIPTION

An ActiveRecord JDBC Adapter for NuoDB.

## Usage

1.  Include NuoDB information in the database.yml file; in addition to the
    following you may also specify the :host and :port properties for each:

        development:
          adapter: nuodb
          database: development
          schema: test
          username: dba
          password: baz

        test:
          adapter: nuodb
          database: development
          schema: test
          username: dba
          password: baz

        production:
          adapter: nuodb
          database: development
          schema: test
          username: dba
          password: baz

2.  In the Gemfile, call the nuodb gem with:

        jruby -S gem 'activerecord-jdbcnuodb-adapter'

3.  Optionally integrate rake db:test tasks (see below).


### SUPPORTING RAILS DB MIGRATE TASKS

We are making the driver compliant with the rake task interfaces in the :db
namespace. You can now use standard rake tasks for just about everything
except for creating the actual databases.

The only problem is that the rails tasks themselves are not open or extensible
in a manner that a driver can extend. As such there are a few integration
points necessary on the application side of the house; this section details
them.

Place the following content in your lib/override_task.rb file:

    Rake::TaskManager.class_eval do
      def alias_task(fq_name)
        new_name = "#{fq_name}:original"
        @tasks[new_name] = @tasks.delete(fq_name)
      end
    end

    def alias_task(fq_name)
      Rake.application.alias_task(fq_name)
    end

    def alias_task_chain(*args, &block)
      name, params, deps = Rake.application.resolve_args(args.dup)
      fq_name = Rake.application.instance_variable_get(:@scope).to_a.reverse.push(name).join(':')
      alias_task(fq_name)
      Rake::Task.define_task(*args, &block)
    end

Then in your lib/tasks/databases.rake script add the following content:

    require 'override_task'

    namespace :db do

      namespace :structure do

        alias_task_chain :dump => :environment do
          if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'nuodb'
            puts 'Task db:structure:dump skipped for NuoDB.'
          else
            Rake::Task['db:structure:dump:original'].execute
          end
        end

      end

      namespace :test do

        alias_task_chain :purge => [:environment, :load_config] do
          if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'nuodb'
            ActiveRecord::Base.establish_connection(:test)
            ActiveRecord::Base.connection.execute("drop schema #{ActiveRecord::Base.configurations[Rails.env]['schema']} cascade;")
          else
            Rake::Task['db:test:purge:original'].execute
          end
        end

        alias_task_chain :clone_structure => 'db:structure:dump' do
          if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'nuodb'
            puts 'Task db:structure:clone_structure skipped for NuoDB.'
          else
            Rake::Task['db:test:clone_structure:original'].execute
          end
        end

      end

    end

With these changes to your Rails application you will be able to run
db:test:prepare tasks or similar.

## ENVIRONMENT SETUP

### MAC

To set up JRuby on Mac, you may optimally install RVM and use that to install
JRuby, or you may also install it from the package installer available online
which requires additional environment setup.

For Mac, run the package installer available at:

    http://jruby.org.s3.amazonaws.com/downloads/1.7.2/JRuby-1.7.2.dmg

Then update your path so that the Gem from JRuby is first on your path ahead
of the system installed ruby:

    export PATH=/Library/Frameworks/JRuby.framework/Versions/Current/bin:$PATH

## BUILDING THE GEM

To compile and test run this command:

    jruby -S rake clean build rdoc spec

## INSTALLING THE GEM

    jruby -S gem install activerecord-jdbcnuodb-adapter-1.0.3.gem

Or from the source tree:

    jruby -S gem install pkg/activerecord-jdbcnuodb-adapter-1.0.3.gem

## TESTING THE GEM

Start up a minimal chorus as follows:

    java -jar ${NUODB_ROOT}/jar/nuoagent.jar --broker &
    ${NUODB_ROOT}/bin/nuodb --chorus test --password bar --dba-user dba --dba-password baz --verbose debug --archive /var/tmp/nuodb --initialize --force &
    ${NUODB_ROOT}/bin/nuodb --chorus test --password bar --dba-user dba --dba-password baz &

Create a user in the database:

    ${NUODB_ROOT}/bin/nuosql test@localhost --user dba --password baz
    > create user dba password 'baz';
    > exit

Run the tests:

    export CLASSPATH=${NUODB_ROOT}/jar/nuodbjdbc.jar
    jruby -S rake spec

## TRYING THE SAMPLE

1.  Install the NuoDB gems:

        jruby -S gem install rails
        jruby -S gem install jdbc-nuodb-1.2.gem
        jruby -S gem install activerecord-jdbcnuodb-adapter-1.2.gem

2.  Verify the gems are installed:

        jruby -S gem list

3.  Run the sample:

        export CLASSPATH=/path/to/nuodb/jar/nuodbjdbc.jar
        jruby samples/sample.rb


## PUBLISHING THE GEM

### TAGGING

Tag the product using tags per the SemVer specification; our tags have a
v-prefix:

    git tag -a v1.2 -m "SemVer Version: v1.2"
    git push --tags

If you make a mistake, take it back quickly:

    git tag -d v1.2
    git push origin :refs/tags/v1.0.3

### PUBLISHING

Here are the commands used to publish:

    jruby -S gem push pkg/activerecord-jdbcnuodb-adapter-1.2.gem

## INSPECTING THE GEM

It is often useful to inspect the contents of a Gem before distribution. To do
this you dump the contents of a gem thus:

    gem unpack pkg/activerecord-jdbcnuodb-adapter-1.2.gem

## REFERENCES

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/74e4ed41ce2e3147bdd475979e32e309 "githalytics.com")](http://githalytics.com/nuodb/activerecord-jdbcnuodb-adapter)

