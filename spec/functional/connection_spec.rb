require 'rubygems'
require 'java'
require 'jdbc/nuodb'

describe Jdbc::NuoDB do
  before do
    Jdbc::NuoDB.load_driver
    java_import Jdbc::NuoDB.driver_name
    java_import 'java.sql.DriverManager'
  end

  after do
  end

  context "creating a connection" do

    before(:each) do
      begin
        java_import java.lang.Class
        java.lang.Class.forName(Jdbc::NuoDB.driver_name).newInstance
        JavaLang::Class.forName(Jdbc::NuoDB.driver_name).newInstance
      rescue JavaLang::ClassNotFoundException => e
        puts "ClassNotFoundException: %s\n" % e
      end
    end

    after(:each) do
    end

    it "should raise an ArgumentError error when provided no configuration" do
      lambda {
        Jdbc::NuoDB.load_driver
        java_import Jdbc::NuoDB.driver_name
        java_import 'java.sql.DriverManager'

        java.lang.Class.forName(Jdbc::NuoDB.driver_name).newInstance
        url = "jdbc:com.nuodb://localhost:48004:test?schema=test"
        JavaSql::DriverManager.getConnection(url)
      }.should raise_error(ArgumentError)
    end
  end
end