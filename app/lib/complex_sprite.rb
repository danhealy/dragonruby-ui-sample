# For drawing several connected sprites as a single render_target
class ComplexSprite
  # ID for the render_target, and the render_target itself.
  attr_accessor :target_name, :target

  # Width and Height is the total size of components.
  # Min width and Min height is the smallest possible total size.
  attr_accessor :width, :min_width, :height, :min_height

  # These should be individual sprites
  attr_accessor :components

  # These are set when requesting the containing_sprite and are used to populate #rect
  attr_accessor :last_x, :last_y

  def initialize(target_name)
    @target_name = target_name
  end

  # Add the component sprites to the render target.
  def redraw
    @target.static_sprites << @components
  end

  # Recalculate width and height based on minimums, then recreate the render target
  def resize(width, height)
    @width  = [width,  @min_width ].max
    @height = [height, @min_height].max
    create_target
  end

  def create_target
    @target = $gtk.args.render_target(@target_name)
    @target.width  = @width
    @target.height = @height
  end

  def rect
    [@last_x, @last_y, @width, @height]
  end

  def containing_sprite(x=0, y=0)
    @last_x = x
    @last_y = y
    Sprite.new.tap do |s|
      s.x = x
      s.y = y
      s.w = @width
      s.h = @height
      s.path = @target_name
      s.source_x = 0
      s.source_y = 0
      s.source_w = @width
      s.source_h = @height
    end
  end
end
