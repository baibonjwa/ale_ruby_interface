# ale_ruby_interface

[![Gem Version](https://badge.fury.io/rb/ale_ruby_interface.svg)](https://badge.fury.io/rb/ale_ruby_interface)

A ruby version of the arcade learning environment interface.

## Description:

ale_ruby_interface is base on [The Arcade Learning Environment](https://github.com/mgbellemare/Arcade-Learning-Environment) and provide a ruby version interface. 

## Installation

ale_ruby_interface have depencency with follow library.

  - [NMatrix](https://github.com/SciRuby/nmatrix)
  - [SDL1.2](https://www.libsdl.org/)
  - [ruby-ffi](https://github.com/ffi/ffi)

### Basic Installation

```shell
gem install ale_ruby_interface
```

## Usages


```ruby
require 'ale_ruby_interface'

ale = ALEInterface.new
# A.L.E: Arcade Learning Environment (version 0.6.0)
# [Powered by Stella]
# Use -help for help screen.
#  => #<ALEInterface:0x007fc7a4048238 @obj=#<FFI::Pointer # address=0x007fc7a267c990>>

ale.load_ROM('./pong.bin')
# Game console created:
#  ROM file:  ./pong.bin
#  Cart Name: Video Olympics (1978) (Atari)
#  Cart MD5:  60e0ea3cbe0913d39803477945e9e5ec
#  Display Format:  AUTO-DETECT ==> NTSC
#  ROM Size:        2048
#  Bankswitch Type: AUTO-DETECT ==> 2K


# WARNING: Possibly unsupported ROM: mismatched MD5.
# Cartridge_MD5: 60e0ea3cbe0913d39803477945e9e5ec
# Cartridge_name: Video Olympics (1978) (Atari)

# Running ROM file...
# Random seed is 0
#  => #<FFI::Pointer address=0x00000000000000>

action_set = ale.get_minimal_action_set() # => [0, 1, 3, 4, 11, 12]
ale.act(action_set[0]) # => 0
ale.get_screen_RGB() # => #<NMatrix:0x007f9d860d1d00 shape:[160,210,3] dtype:int16 stype:dense>

```



## Documents

http://www.rubydoc.info/github/happybai/ale_ruby_interface/master


<!--
## FAQ

TBD





sudo apt-get install libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev cmake

mkdir build && cd build
cmake -DUSE_SDL=ON -DUSE_RLGLUE=OFF -DBUILD_EXAMPLES=ON ..
make -j 4



NMatrix workaround

mv /usr/local/bin/gcc-4.9 /usr/local/bin/gcc-4.9-orig
mv /usr/local/bin/g++-4.9 /usr/local/bin/g++-4.9-orig
ln -s $(which clang) /usr/local/bin/gcc-4.9
ln -s $(which clang++) /usr/local/bin/g++-4.9
gem install nmatrix
rm /usr/local/bin/gcc-4.9 /usr/local/bin/g++-4.9
mv /usr/local/bin/gcc-4.9-orig /usr/local/bin/gcc-4.9
mv /usr/local/bin/g++-4.9-orig /usr/local/bin/g++-4.9
 -->
