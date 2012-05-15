require File.expand_path('../../../spec_helper', __FILE__)
require "open3"

describe "Open3.popen3" do
  after :each do
    [@in, @out, @err].each do |stream|
      stream.close if stream and !stream.closed?
    end
  end

  it "returns an open stdin" do
    @in, @out, @err = Open3.popen3("cat")
    @in.closed?.should be_false
  end

  it "returns an open stdout" do
    @in, @out, @err = Open3.popen3("cat")
    @out.closed?.should be_false
  end

  it "returns an open stderr" do
    @in, @out, @err = Open3.popen3("cat")
    @err.closed?.should be_false
  end

  it "returns a write-only stdin" do
    @in, @out, @err = Open3.popen3("cat")
    lambda { @in.read(1) }.should raise_error
  end

it "returns a read-only stdout" do
    @in, @out, @err = Open3.popen3("cat")
    lambda { @out.write('foo') }.should raise_error(IOError)
  end

  it "returns a read-only stderr" do
    @in, @out, @err = Open3.popen3("cat")
    lambda { @out.write('foo') }.should raise_error(IOError)
  end

  it "returns a readable stdout" do
    @in, @out, @err = Open3.popen3("echo foo")
    @out.read.should == "foo\n"
  end

  it "reads and writes successfully" do
    @in, @out, @err = Open3.popen3("cat")
    @in.write("foo")
    @in.close
    @out.read(3).should == "foo"
  end

  it "accepts an array arg giving path and argv[0] for execve" do
    lambda {
      @in, @out, @err = Open3.popen3(["/bin/cat", "cat"])
    }.should_not raise_error(NoMethodError)
  end

  it "accepts an array arg giving path and argv[0] for execve, with args" do
    lambda {
      @in, @out, @err = Open3.popen3(["/bin/echo", "echo"], "foo")
    }.should_not raise_error(NoMethodError)
  end

  it "functions with an array arg giving path and argv[0] for execve, w/args" do
    @in, @out, @err = Open3.popen3(["/bin/echo", "echo"], "foo")
    @out.read.should == "foo\n"
  end
end
