# This is basically the opposite of three_panel.  The sides are stretched and the center is fixed.
# Meant for complex edges in the nine panel.
# At least one side must be present, but the rest is optional.
# Responds to #stretch, #max_height, #min_width
class NinePanelEdge
  include Assignable

  attr_accessor :id, :target, :ready, :width, :height

  # These are expected to be nil or the name of a 1px wide stretchable sprite
  %i[left_edge right_edge].each do |edge|
    attr_accessor "#{edge}_path", "#{edge}_height", "cur_#{edge}_width", edge
  end

  attr_accessor :transition_path, :transition_height, :transition_width, :transition

  # Need to set at least one of left/right_edge, and optionally a transition, after initialize
  def initialize(id)
    @id = id
    @left_edge_height = 0
    @right_edge_height = 0
    @transition_width = 0
    @transition_height = 0
    @ready = false
  end

  # This must be manually called once after setting up component edges
  # Creates the sprites for the different segments based on what's been set
  # Either left or right edge must be present, and @ready is set based on this.  Transition is optional.
  def init_sprites
    if @left_edge_path
      @left_edge = Sprite.new.tap do |edge|
        edge.path = @left_edge_path
        edge.h = @left_edge_height
        edge.w = @cur_left_edge_width
      end
    end

    if @right_edge_path
      @right_edge = Sprite.new.tap do |edge|
        edge.path = @right_edge_path
        edge.h = @right_edge_height
        edge.w = @cur_right_edge_width
      end
    end

    if @transition_path
      @transition = Sprite.new.tap do |edge|
        edge.path = @transition_path
        edge.h = @transition_height
        edge.w = @transition_width
      end
    end

    @ready = [@left_edge, @right_edge].any?
  end

  def max_height
    [@left_edge_height, @right_edge_height, @transition_height].max
  end

  def min_width
    (@left_edge_path ? 1 : 0) + @transition_width + (@right_edge_path ? 1 : 0)
  end

  # Given a goal width, stretch the given segments across it
  # If only one of left/right edge is given, that will just be stretched to fit
  # If a transition is given, it will be placed after "left" but before "right" and not stretched
  # If both left and right are given, the goal width is divided between them and the left side is prefered if it's odd
  def stretch(x, y, new_width=min_width)
    raise "Must call #init_sprites after setting left/right edges and transition" unless @ready

    @width = [new_width, min_width].max.floor
    @height = max_height

    # Set side width
    if @left_edge && @right_edge
      # TODO: Allow setting a max width.  Right now this places the transition exactly in the center.
      each_side_width, extra_for_left_side = (@width - @transition_width).divmod(2)
      @cur_left_edge_width = each_side_width + extra_for_left_side
      @cur_right_edge_width = each_side_width
    else
      @cur_left_edge_width = @cur_right_edge_width = (@width - @transition_width)
    end

    cur_x = x
    if @left_edge
      @left_edge.x = cur_x
      @left_edge.y = (max_height - @left_edge_height) + y
      @left_edge.w = @cur_left_edge_width
      cur_x += @cur_left_edge_width
    end

    if @transition
      @transition.x = cur_x
      @transition.y = (max_height - @transition_height) + y
      cur_x += @transition_width
    end

    if @right_edge
      @right_edge.x = cur_x
      @right_edge.y = (max_height - @right_edge_height) + y
      @right_edge.w = @cur_right_edge_width
    end

    sprites
  end

  def sprites
    [@left_edge, @transition, @right_edge]
  end
end
