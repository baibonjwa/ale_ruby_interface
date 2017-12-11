require 'ffi'
require 'nmatrix'

module ALELib
  extend FFI::Library
  ffi_lib '/Users/happybai/Arcade-Learning-Environment/ale_python_interface/libale_c.so'
  attach_function :ALE_new, [], :void
  attach_function :ALE_del, [:void], :void
  attach_function :getString, [:void, :char], :char
  attach_function :getInt, [:void, :char], :int
  attach_function :getBool, [:void, :char], :bool
  attach_function :getFloat, [:void, :char], :float 
  attach_function :setString, [:void, :char, :char], :void
  attach_function :setInt, [:void, :char, :int], :void
  attach_function :setBool, [:void, :char, :bool], :void
  attach_function :setFloat, [:void, :char, :float], :void
  attach_function :loadROM, [:void, :char], :void
  attach_function :act, [:void, :int], :int
  attach_function :game_over, [:void], :bool
  attach_function :reset_game, [:void], :void
  attach_function :getAvailableModes, [:void, :void], :void
  attach_function :getAvailableModesSize, [:void], :int
  attach_function :setMode, [:void, :int], :void
  attach_function :getAvailableDifficulties, [:void, :void], :void
  attach_function :getAvailableDifficultiesSize, [:void], :int
  attach_function :setDifficulty, [:void, :int], :void
  attach_function :getLegalActionSet, [:void, :void], :void
  attach_function :getLegalActionSize, [:void], :int
  attach_function :getMinimalActionSet, [:void, :void], :void
  attach_function :getMinimalActionSize, [:void], :int
  attach_function :getFrameNumber, [:void], :int
  attach_function :lives, [:void], :int
  attach_function :getEpisodeFrameNumber, [:void], :int
  attach_function :getScreen, [:void, :void], :void
  attach_function :getRAM, [:void, :void], :void
  attach_function :getRAMSize, [:void], :int
  attach_function :getScreenWidth, [:void], :int
  attach_function :getScreenHeight, [:void], :int
  attach_function :getScreenRGB, [:void, :void], :void
  attach_function :getScreenGrayscale, [:void, :void], :void
  attach_function :saveState, [:void], :void
  attach_function :loadState, [:void], :void
  attach_function :cloneState, [:void], :void
  attach_function :restoreState, [:void, :void], :void
  attach_function :cloneSystemState, [:void], :void
  attach_function :restoreSystemState, [:void, :void], :void
  attach_function :deleteState, [:void], :void
  attach_function :saveScreenPNG, [:void, :char], :void
  attach_function :encodeState, [:void, :void, :int], :void
  attach_function :encodeStateLen, [:void], :int
  attach_function :decodeState, [:void, :int], :void
  attach_function :setLoggerMode, [:int], :void
end

class ALEInterface
  # include ALELib

  def initialize
    @obj = ALELib.ALE_new
  end

  def get_string(key)
    return ALELib.getString(@obj, key)
  end

  def get_int(key)
    return ALELib.getInt(@obj, key)
  end

  def get_bool(key)
    return ALELib.getBool(@obj, key)
  end

  def get_float(key)
    return ALELib.getFloat(@obj, key)
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

  def load_rom(rom_file)
    ALELib.loadROM(@obj, rom_file)
  end

  def act(action)
    return ALELib.act(@obj, action.to_i)
  end

  def game_over
    return ALELib.game_over(@obj)
  end

  def reset_game
    ALELib.game_over(@obj)
  end

  def get_legal_action_set
    act_size = ALELib.getLegalActionSize(@obj)
    act = NMatrix.zeros[act_size]
    ALELib.getLegalActionSet(@obj, act)
    return act
  end

  def get_minimal_action_set
  end

  def get_available_modes
  end

  def set_mode
  end

  def get_available_difficuties
  end

  def set_difficulty
  end

  def set_legal_action_set
  end

  def set_minimal_action_set
  end

  def get_frame_number
  end

  def lives
  end

  def get_episode_frame_number
  end

  def get_screen_dims
  end

  def get_screen
  end

  def get_screen_RGB
  end

  def get_screen_grayscale
  end

  def get_RAM_size
  end

  def get_RAM
  end

  def save_screen_PNG
  end

  def save_state
  end

  def load_state
  end

  def clone_state
  end

  def restore_state
  end

  def clone_system_state
  end

  def restore_system_state
  end

  def delete_state
  end

  def encode_state_len
  end

  def encode_state
  end
  
  def decode_state
  end

end