require 'minitest/autorun'
require 'ale_ruby_interface'
require 'pry'

class ALEInterfaceTest < Minitest::Test

  def test_hello_world
    assert_equal "hello world", "Hello world"
  end

  def test_hello_world2
    assert_equal "hello world", "Hello world"
  end

end