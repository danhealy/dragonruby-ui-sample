# Define a set of sprites for both the pressed state and the normal state
# Use #toggle_pressed to switch states
# Override the height methods to center the label
# #resize and #redraw should occur in subclass initialize
class TwoStageButton < ComplexSprite
  attr_accessor :normal, :pressed, :is_pressed, :label

  def initialize(target_name)
    super(target_name)
    @normal = []
    @pressed = []
    @is_pressed = false
  end

  def pressed_height
    0
  end

  def normal_height
    0
  end

  def label_y_offset
    4
  end

  def label_y_pressed_offset
    6
  end

  def cur_height
    @is_pressed ? pressed_height : normal_height
  end

  def toggle_pressed
    create_target
    @is_pressed = !@is_pressed
    redraw
  end

  def redraw
    @components = @is_pressed ? @pressed : @normal
    super()
    return unless @label

    @target.static_labels << @label.label_attrs.merge(
      {
        x: (width / 2).floor,
        y: ((pressed_height + @label.min_height) / 2) + label_y_offset - (@is_pressed ? label_y_pressed_offset : 0)
      }
    )
  end
end
