require 'ffi'
require 'nmatrix'
require 'fileutils'

##
# Module for connecting to libale_c.so
module ALELib
  extend FFI::Library
  ffi_lib File.join(File.dirname(__FILE__), "libale_c.so")
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

##
# This is the main class

class ALEInterface

  ##
  # initialize method
  def initialize
    # if ale.cfg doesn't exist, will create one.
    src = File.join(File.dirname(__FILE__), "ale.cfg")
    dest = './ale.cfg'
    if !File.exist?('./ale.cfg')
      FileUtils.cp(src, dest)
      puts "Created ale.cfg successfully"
    end
    @obj = ALELib.ALE_new
  end

  ##
  # Gets the value of any flag passed as parameter that has a string value
  def get_string(key)
    ALELib.getString(@obj, key)
  end

  ##
  # Gets the value of any flag passed as parameter that has an integer value
  def get_int(key)
    ALELib.getInt(@obj, key)
  end

  ##
  # Gets the value of any flag passed as parameter that has a boolean value
  def get_bool(key)
    ALELib.getBool(@obj, key)
  end

  ##
  # Gets the value of any flag passed as parameter that has a float value
  def get_float(key)
    ALELib.getFloat(@obj, key)
  end

  ##
  # Sets the value of any flag that has a string type
  def set_string(key, value)
    ALELib.setString(@obj, key, value)
  end

  ##
  # Sets the value of any flag that has an integer type
  def set_int(key, value)
    ALELib.setInt(@obj, key, value)
  end

  ##
  # Sets the value of any flag that has a boolean type
  def set_bool(key, value)
    ALELib.setBool(@obj, key, value)
  end

  ##
  # Sets the value of any flag that has a float type
  def set_float(key, value)
    ALELib.setFloat(@obj, key, value)
  end

  ##
  # TODO: load_ROM method
  def load_ROM(rom_file)
    ALELib.loadROM(@obj, rom_file)
  end

  ##
  # Applies an action to the game and returns the reward.
  # It is the user’s responsibility to check if the game has ended and to reset it when necessary (this method will keep pressing buttons on the game over screen).
  def act(action)
    ALELib.act(@obj, action.to_i)
  end

  ##
  # Indicates if the game has ended.
  def game_over
    ALELib.game_over(@obj)
  end

  ##
  # Resets the game, but not the full system (it is not “equivalent” to un- plugging the console from electricity).
  def reset_game
    ALELib.reset_game(@obj)
  end

  ##
  # Returns the vector of legal actions (all the 18 actions).
  # This should be called only after the ROM is loaded.
  def get_legal_action_set
    act_size = ALELib.getLegalActionSize(@obj)
    act = NMatrix.zeros [act_size]
    FFI::MemoryPointer.new(:int, act.size) do |p|
      p.put_array_of_int(0, act)
      ALELib.getLegalActionSet(@obj, p)
      return p.read_array_of_int(act_size)
    end
  end

  ##
  # Returns the vector of the minimal set of actions needed to play the game (all actions that have some effect on the game).
  # This should be called only after the ROM is loaded.
  def get_minimal_action_set
    act_size = ALELib.getMinimalActionSize(@obj)
    act = NMatrix.zeros [act_size]
    FFI::MemoryPointer.new(:int, act.size) do |p|
      p.put_array_of_int(0, act)
      ALELib.getMinimalActionSet(@obj, p)
      return p.read_array_of_int(act_size)
    end
  end

  ##
  # Returns the vector of modes available for the current game.
  # This should be called only after the ROM is loaded.
  def get_available_modes
    modes_size = ALELib.getAvailableModesSize(@obj)
    modes = NMatrix.zeros [modes_size]
    FFI::MemoryPointer.new(:int, modes.size) do |p|
      p.put_array_of_int(0, modes)
      ALELib.getAvailableModes(@obj, p)
      return p.read_array_of_int(modes_size)
    end
  end

  ##
  # Sets the mode of the game. The mode must be an available mode (otherwise it throws an exception).
  # This should be called only after the ROM is loaded.
  def set_mode(mode)
    ALELib.set_mode(@obj, mode)
  end

  ##
  # Returns the vector of difficulties available for the current game.
  # This should be called only after the ROM is loaded.
  def get_available_difficulties
    difficulties_size = ALELib.getAvailableDifficultiesSize(@obj)
    difficulties = NMatrix.zeros [difficulties_size]
    FFI::MemoryPointer.new(:int, difficulties.size) do |p|
      p.put_array_of_int(0, difficulties)
      ALELib.getAvailableDifficulties(@obj, p)
      return p.read_array_of_int(difficulties_size)
    end
  end

  ##
  # Sets the difficulty of the game. The difficulty must be an available mode (otherwise it throws an exception).
  # This should be called only after the ROM is loaded.
  def set_difficulty(difficulty)
    ALELib.set_mode(@obj, difficulty)
  end

  ##
  # Returns the current frame number since the loading of the ROM.
  def get_frame_number
    ALELib.getFrameNumber(@obj)
  end

  ##
  # Returns the agent’s remaining number of lives. If the game does not have the concept of lives (e.g. Freeway), this function returns 0.
  def lives
    ALELib.lives(@obj)
  end

  ##
  # Returns the current frame number since the start of the cur- rent episode.
  def get_episode_frame_number
    ALELib.getEpisodeFrameNumber(@obj)
  end

  ##
  # get_screen_dims method
  def get_screen_dims
    width = ALELib.getScreenWidth(@obj)
    height = ALELib.getScreenHeight(@obj)
    { width: width, height: height }
  end

  ##
  # Returns a matrix containing the current game screen.
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

  ##
  # This method fills the given vector with a RGB version of the current screen, provided in row, column, then colour channel order (typically yielding 210 × 160 × 3 = 100, 800 entries). The colour channels themselves are, in order: R, G, B. For example, output_rgb_buffer[(160 * 3) * 1 + 52 * 3 + 1] corresponds to the 2nd row, 53rd column pixel’s green value. The vector is resized as needed. Still, for efficiency it is recommended to initialize the vector beforehand, to make sure an allocation is not performed at each time step.
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

  ##
  # This method fills the given vector with a grayscale version of the current screen, provided in row- major order (typically yielding 210 × 160 = 33, 600 entries). The vector is resized as needed. For efficiency it is recommended to initialize the vector beforehand, to make sure an allocation is not performed at each time step. Note that the grayscale value corresponds to the pixel’s luminance; for more details, consult the web.
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

  ##
  # get_RAM_size method
  def get_RAM_size
    ALELib.getRAMSize(@obj)
  end

  ##
  # Returns a vector containing current RAM content (byte-level).
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

  ##
  # Saves the current screen as a png file.
  def save_screen_PNG(filename)
    return ALELib.saveScreenPNG(@obj, filename)
  end

  ##
  # Saves the current state of the system if one wants to be able to recover a state in the future; e.g. in search algorithms.
  def save_state
    return ALELib.saveState(@obj)
  end

  ##
  # Loads a previous saved state of the system once we have a state saved.
  def load_state
    return ALELib.loadState(@obj)
  end

  ##
  # Makes a copy of the environment state. This copy does not include pseudo-randomness, making it suitable for planning purposes. By contrast, see cloneSystemState.
  def clone_state
    return ALELib.cloneState(@obj)
  end

  ##
  # Reverse operation of cloneState(). This does not restore pseudo-randomness, so that repeated calls to restoreState() in the stochastic controls setting will not lead to the same outcomes. By contrast, see restoreSystemState.
  def restore_state(state)
    ALELib.restoreState(@obj, state)
  end

  ##
  # This makes a copy of the system and environment state, suitable for serialization. This includes pseudo-randomness and so is not suitable for planning purposes.
  def clone_system_state
    return ALELib.cloneSystemState(@obj)
  end

  ##
  # Reverse operation of cloneSystemState.
  def restore_system_state
    ALELib.restoreSystemState(@obj)
  end

  ##
  # delete_state method
  def delete_state(state)
    ALELib.deleteState(state)
  end

  ##
  # encode_state_len method
  def encode_state_len(state)
    return ALELib.encodeStateLen(state)
  end

  ##
  # encode_staten method
  def encode_state; end

  ##
  # encode_staten method
  def decode_state; end

  private

  def as_types; end
end
