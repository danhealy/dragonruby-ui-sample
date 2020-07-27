# Expects to be included in classes which are sprites (using attr_sprite)
# Allows assignment of sprite ivars using a hash
# Does not assign x/y
module Assignable
  def assign(sprite)
    @w      = sprite[:w]
    @h      = sprite[:h]
    @path   = sprite[:path]
    @angle  = sprite[:angle]
    @a      = sprite[:a]
    @r      = sprite[:r]
    @g      = sprite[:g]
    @b      = sprite[:b]
    @tile_x = sprite[:tile_x]
    @tile_y = sprite[:tile_y]
    @tile_w = sprite[:tile_w]
    @tile_h = sprite[:tile_h]
  end
end
