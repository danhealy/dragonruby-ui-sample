# # For progress bars, etc, where the sides are fixed and the center can be stretched
# class ThreePanel < ComplexSprite
#   attr_accessor :left_side, :center, :right_side
#
#   def initialize(target_name)
#     @target_name = target_name
#   end
#
#   def redraw
#     @components = [@left_side, @center, @right_side]
#     super()
#   end
# end
