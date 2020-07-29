module Zif
  # Just a basic sprite which has assignable and serializable functionality
  class Sprite
    include Zif::Assignable
    include Zif::Serializable
    attr_sprite
  end
end
