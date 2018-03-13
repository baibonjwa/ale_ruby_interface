require 'minitest/autorun'
require 'ale_ruby_interface'
require 'pry'
require 'nmatrix'

class ALEInterfaceTest < Minitest::Test

  def setup
    @ale = ALEInterface.new
    pong_path = './pong.bin'
    @ale.load_ROM(pong_path)
  end

  def test_ale_interface_initialize
    assert @ale != nil
  end

  def test_load_ROM()
    pong_path = './pong.bin'
    assert @ale.load_ROM(pong_path).is_a?(FFI::Pointer)
  end

  def test_get_legal_action_set
    results = @ale.get_legal_action_set
    assert results.is_a?(Array)
    assert_equal([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], results)
  end

  def test_minimal_action_set
    results = @ale.get_minimal_action_set
    assert results.is_a?(Array)
    assert_equal([0, 1, 3, 4, 11, 12], results)
  end

  def test_get_available_modes
    results = @ale.get_available_modes
    assert results.is_a?(Array)
    assert_equal([0, 1], results)
  end

  def test_get_available_difficulties
    results = @ale.get_available_difficulties
    assert results.is_a?(Array)
    assert_equal([0, 1], results)
  end

  def test_get_frame_number
    assert_equal(0, @ale.get_frame_number)
  end

  def test_lives
    assert_equal(0, @ale.lives)
  end

  def test_get_episode_frame_number
    assert_equal(0, @ale.get_episode_frame_number)
  end

  def test_get_screen_dims 
    results = @ale.get_screen_dims
    assert_equal(160, results[:width])
    assert_equal(210, results[:height])
  end

  def test_get_screen
    results = @ale.get_screen
    assert_equal(160 * 210, results.size)
  end

  def test_get_screen_RGB
    results = @ale.get_screen_RGB
    assert_equal(160 * 210 * 3, results.size)
  end

  def test_get_screen_grayscale
    results = @ale.get_screen_grayscale
    assert_equal(160 * 210 * 1, results.size)
  end

  def get_RAM_size
    assert_equal(0, @ale.get_RAM_size)
  end

  def test_get_RAM
    results = @ale.get_RAM
    assert_equal(128, results.size)
  end

  def test_smoke
    action_set = @ale.get_minimal_action_set()
    @ale.act(action_set[0])
    rgb = @ale.get_screen_RGB()
    ram = @ale.get_RAM()
    grayscale = @ale.get_screen_grayscale()
    assert_equal(160 * 210 * 3, rgb.size)
    assert_equal(128, ram.size)
    assert_equal(160 * 210, grayscale.size)
  end

end