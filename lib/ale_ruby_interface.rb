require 'ffi'
require 'nmatrix'

module ALELib
  extend FFI::Library
  ffi_lib '/Users/happybai/Arcade-Learning-Environment/ale_python_interface/libale_c.so'
  attach_function :ALE_new, [], :pointer
  attach_function :ALE_del, [:pointer], :pointer
  attach_function :getString, [:pointer, :string], :string
  attach_function :getInt, [:pointer, :string], :int
  attach_function :getBool, [:pointer, :string], :bool
  attach_function :getFloat, [:pointer, :string], :float
  attach_function :setString, [:pointer, :string, :string], :pointer
  attach_function :setInt, [:pointer, :string, :int], :pointer
  attach_function :setBool, [:pointer, :string, :bool], :pointer
  attach_function :setFloat, [:pointer, :string, :float], :pointer
  attach_function :loadROM, [:pointer, :string], :pointer
  attach_function :act, [:pointer, :int], :long
  attach_function :game_over, [:pointer], :bool
  attach_function :reset_game, [:pointer], :pointer
  attach_function :getAvailableModes, [:pointer, :pointer], :pointer
  attach_function :getAvailableModesSize, [:pointer], :int
  attach_function :setMode, [:pointer, :int], :pointer
  attach_function :getAvailableDifficulties, [:pointer, :pointer], :pointer
  attach_function :getAvailableDifficultiesSize, [:pointer], :int
  attach_function :setDifficulty, [:pointer, :int], :pointer
  attach_function :getLegalActionSet, [:pointer, :pointer], :pointer
  attach_function :getLegalActionSize, [:pointer], :int
  attach_function :getMinimalActionSet, [:pointer, :pointer], :pointer
  attach_function :getMinimalActionSize, [:pointer], :int
  attach_function :getFrameNumber, [:pointer], :int
  attach_function :lives, [:pointer], :int
  attach_function :getEpisodeFrameNumber, [:pointer], :int
  attach_function :getScreen, [:pointer, :pointer], :pointer
  attach_function :getRAM, [:pointer, :pointer], :pointer
  attach_function :getRAMSize, [:pointer], :int
  attach_function :getScreenWidth, [:pointer], :int
  attach_function :getScreenHeight, [:pointer], :int
  attach_function :getScreenRGB, [:pointer, :pointer], :pointer
  attach_function :getScreenGrayscale, [:pointer, :pointer], :pointer
  attach_function :saveState, [:pointer], :pointer
  attach_function :loadState, [:pointer], :pointer
  attach_function :cloneState, [:pointer], :pointer
  attach_function :restoreState, [:pointer, :pointer], :pointer
  attach_function :cloneSystemState, [:pointer], :pointer
  attach_function :restoreSystemState, [:pointer, :pointer], :pointer
  attach_function :deleteState, [:pointer], :pointer
  attach_function :saveScreenPNG, [:pointer, :string], :pointer
  attach_function :encodeState, [:pointer, :pointer, :int], :pointer
  attach_function :encodeStateLen, [:pointer], :int
  attach_function :decodeState, [:pointer, :int], :pointer
  attach_function :setLoggerMode, [:int], :pointer
end

class ALEInterface
  def initialize
    # setup config file manually
    # ale_path = ENV['ale_path'] || '/Users/happybai/Arcade-Learning-Environment'
    # base_path = "#{Dir.pwd}/lib"
    # Dir.chdir base_path
    @obj = ALELib.ALE_new
    # Dir.chdir base_path
  end

  def get_string(key)
    ALELib.getString(@obj, key)
  end

  def get_int(key)
    ALELib.getInt(@obj, key)
  end

  def get_bool(key)
    ALELib.getBool(@obj, key)
  end

  def get_float(key)
    ALELib.getFloat(@obj, key)
  end

  def set_string(key, value)
    ALELib.setString(@obj, key, value)
  end

  def set_int(key, value)
    ALELib.setInt(@obj, key, value)
  end

  def set_bool(key, value)
    ALELib.setBool(@obj, key, value)
  end

  def set_float(key, value)
    ALELib.setFloat(@obj, key, value)
  end

  def load_ROM(rom_file)
    ALELib.loadROM(@obj, rom_file)
  end

  def act(action)
    ALELib.act(@obj, action.to_i)
  end

  def game_over
    ALELib.game_over(@obj)
  end

  def reset_game
    ALELib.game_over(@obj)
  end

  def get_legal_action_set
    act_size = ALELib.getLegalActionSize(@obj)
    act = NMatrix.zeros [act_size]
    FFI::MemoryPointer.new(:int, act.size) do |p|
      p.put_array_of_int(0, act)
      ALELib.getLegalActionSet(@obj, p)
      return p.read_array_of_int(act_size)
    end
  end

  def get_minimal_action_set
    act_size = ALELib.getMinimalActionSize(@obj)
    act = NMatrix.zeros [act_size]
    FFI::MemoryPointer.new(:int, act.size) do |p|
      p.put_array_of_int(0, act)
      ALELib.getMinimalActionSet(@obj, p)
      return p.read_array_of_int(act_size)
    end
  end

  def get_available_modes
    modes_size = ALELib.getAvailableModesSize(@obj)
    modes = NMatrix.zeros [modes_size]
    FFI::MemoryPointer.new(:int, modes.size) do |p|
      p.put_array_of_int(0, modes)
      ALELib.getAvailableModes(@obj, p)
      return p.read_array_of_int(modes_size)
    end
  end

  def set_mode(mode)
    ALELib.set_mode(@obj, mode)
  end

  def get_available_difficulties
    difficulties_size = ALELib.getAvailableDifficultiesSize(@obj)
    difficulties = NMatrix.zeros [difficulties_size]
    FFI::MemoryPointer.new(:int, difficulties.size) do |p|
      p.put_array_of_int(0, difficulties)
      ALELib.getAvailableDifficulties(@obj, p)
      return p.read_array_of_int(difficulties_size)
    end
  end

  def set_difficulty(difficulty)
    ALELib.set_mode(@obj, difficulty)
  end

  def get_frame_number
    ALELib.getFrameNumber(@obj)
  end

  def lives
    ALELib.lives(@obj)
  end

  def get_episode_frame_number
    ALELib.getEpisodeFrameNumber(@obj)
  end

  def get_screen_dims
    width = ALELib.getScreenWidth(@obj)
    height = ALELib.getScreenHeight(@obj)
    { width: width, height: height }
  end

  def get_screen(screen_data = nil)
    # This function fills screen_data with the RAW Pixel data
    width = ALELib.getScreenWidth(@obj)
    height = ALELib.getScreenHeight(@obj)
    size = width * height
    FFI::MemoryPointer.new(:uint8, size) do |p|
      ALELib.getScreen(@obj, p)
      return NMatrix.new(
        [width * height],
        p.read_array_of_uint8(size),
        dtype: :int16
      )
    end
  end

  def get_screen_RGB()
    # This function fills screen_data with the data in RGB format
    width = ALELib.getScreenWidth(@obj)
    height = ALELib.getScreenHeight(@obj)
    size = width * height * 3
    FFI::MemoryPointer.new(:uint8, size) do |p|
      ALELib.getScreenRGB(@obj, p)
      return NMatrix.new(
        [width, height, 3],
        p.read_array_of_uint8(size),
        dtype: :int16
      )
    end
  end

  def get_screen_grayscale(screen_data = nil)
    width = ALELib.getScreenWidth(@obj)
    height = ALELib.getScreenHeight(@obj)
    size = width * height * 1
    FFI::MemoryPointer.new(:uint8, size) do |p|
      ALELib.getScreenGrayscale(@obj, p)
      return NMatrix.new(
        [width, height, 1],
        p.read_array_of_uint8(size),
        dtype: :int16
      )
    end
  end

  def get_RAM_size
    ALELib.getRAMSize(@obj)
  end

  def get_RAM()
    ram_size = ALELib.getRAMSize(@obj)
    FFI::MemoryPointer.new(:uint64, ram_size) do |p|
      ALELib.getRAM(@obj, p)
      return NMatrix.new(
        [ram_size],
        p.read_array_of_uint8(ram_size),
        dtype: :int16
      )
    end
  end

  def save_screen_PNG(filename)
    return ALELib.saveScreenPNG(@obj, filename)
  end

  def save_state
    return ALELib.saveState(@obj)
  end

  def load_state
    return ALELib.loadState(@obj)
  end

  def clone_state
    # This makes a copy of the environment state. This copy does *not*
    # include pseudorandomness, making it suitable for planning
    # purposes. By contrast, see cloneSystemState.
    return ALELib.cloneState(@obj)
  end

  def restore_state(state)
    ALELib.restoreState(@obj, state)
  end

  def clone_system_state
    return ALELib.cloneSystemState(@obj)
  end

  def restore_system_state
    ALELib.restoreSystemState(@obj)
  end

  def delete_state(state)
    ALELib.deleteState(state)
  end

  def encode_state_len(state)
    return ALELib.encodeStateLen(state)
  end

  # TBD
  def encode_state; end

  def decode_state; end

  private

  def as_types; end
end
