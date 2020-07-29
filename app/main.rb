require "app/lib/zif/assignable.rb"
require "app/lib/zif/serializable.rb"
require "app/lib/zif/sprite.rb"
require "app/lib/zif/complex_sprite.rb"
require "app/lib/zif/labels/label.rb"
require "app/lib/zif/components/two_stage_button.rb"
require "app/lib/zif/panels/nine_panel_edge.rb"
require "app/lib/zif/panels/nine_panel.rb"

require "app/ui/labels/future_label.rb"
require "app/ui/panels/glass_panel.rb"
require "app/ui/panels/metal_panel.rb"
require "app/ui/panels/metal_cutout.rb"
require "app/ui/components/progress_bar.rb"
require "app/ui/components/tall_button.rb"

# Controls state for the demo.
class Game
  attr_accessor :cur_color, :button, :counter, :count_progress, :random_lengths

  DEBUG_LABEL_COLOR = { r: 255, g: 255, b: 255 }.freeze

  def initialize
    $gtk.args.outputs.background_color = [0, 0, 0]
    @counter = 0
    @random_lengths = Array.new(10) { rand(160) + 40 }
  end

  def ease(t, total)
    Math.sin(((t / total.to_f) * Math::PI) / 2.0)
  end

  def tick
    $gtk.args.outputs.background_color = [0, 0, 0]

    @cur_color = %i[blue green red white yellow].sample if ($gtk.args.tick_count % @random_lengths[0]).zero?

    display_metal_panel
    display_glass_panel
    display_progress_bar
    display_button
    display_interactable_button
  end

  def display_metal_panel
    cur_w = MetalPanel.min_width + 200 + (200 * ease($gtk.args.tick_count, @random_lengths[1])).floor
    cur_h = MetalPanel.min_height + 200 + (200 * ease($gtk.args.tick_count, @random_lengths[2])).floor
    metal = MetalPanel.new(:metal_panel, cur_w, cur_h, "Hello World", @cur_color)

    $gtk.args.outputs.sprites << metal.containing_sprite(60, 60)
    $gtk.args.outputs.labels << {
      x: 60,
      y: 600,
      text: "Scaling custom 9-slice: #{cur_w}x#{cur_h}"
    }.merge(DEBUG_LABEL_COLOR)

    return unless (cur_w > 75) && (cur_h > 100)

    # Draw the cutout
    cutout = MetalCutout.new(:metal_cutout, cur_w - 50, cur_h - 100)
    $gtk.args.outputs.sprites << cutout.containing_sprite(60 + 25, 60 + 25)
  end

  def display_glass_panel
    cuts = format("%04b", (($gtk.args.tick_count / 60) % 16)).chars.map { |bit| bit == "1" }
    glass = GlassPanel.new(:glass_panel, 600, 600, cuts)

    $gtk.args.outputs.labels << { x: 600, y: 700, text: "Glass panel cuts: #{cuts}" }.merge(DEBUG_LABEL_COLOR)
    $gtk.args.outputs.sprites << glass.containing_sprite(550, 60)
  end

  def display_progress_bar
    cur_progress       = (0.5 + 0.5 * ease($gtk.args.tick_count, @random_lengths[3])).round(4)
    cur_progress_width = 150 + (50 * ease($gtk.args.tick_count, @random_lengths[4])).floor

    prog = ProgressBar.new(:progress, cur_progress_width, cur_progress, @cur_color)
    $gtk.args.outputs.sprites << prog.containing_sprite(600, 500)
    $gtk.args.outputs.labels << {
      x: 600,
      y: 600,
      text: "Progress bar: width #{cur_progress_width}, progress #{(cur_progress * 100).round}%"
    }.merge(DEBUG_LABEL_COLOR)
  end

  def display_button
    cur_button_length = 20 + 200 + (200 * ease($gtk.args.tick_count, @random_lengths[5])).floor
    changing_button = TallButton.new(:colorful_button, cur_button_length, @cur_color, "Don't Press Me")
    $gtk.args.outputs.sprites << changing_button.containing_sprite(600, 300)
  end

  def display_interactable_button
    @button ||= TallButton.new(:static_button, 300, :blue, "Press Me", 2)
    if $args.inputs.mouse.click&.point&.inside_rect? @button.rect
      @button.toggle_pressed
    elsif @button.is_pressed && $args.inputs.mouse.up
      @button.toggle_pressed
      @counter += 1
      @count_progress = ProgressBar.new(:count_progress, 400, 0, @cur_color) if @counter == 1
      @count_progress.progress = @counter / 20.0
    end
    $gtk.args.outputs.sprites << @button.containing_sprite(600, 200)
    $gtk.args.outputs.sprites << @count_progress.containing_sprite(600, 100) if @count_progress
    label_text = "Buttons.  #{"#{@counter}/20 " if @counter.positive?}The bottom one " \
                 "#{@button.is_pressed ? 'is pressed!' : 'can be pressed.'}"
    $gtk.args.outputs.labels << {
      x: 600,
      y: 400,
      text: label_text
    }.merge(DEBUG_LABEL_COLOR)
  end
end

def tick(args)
  $game = args.state.game = Game.new if args.tick_count.zero?

  args.state.game.tick
end
