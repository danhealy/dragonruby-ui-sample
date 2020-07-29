# Settings for the Kenney Future font
class FutureLabel < Zif::Label
  FONT = "sprites/kenney-uipack-space/Fonts/kenvector_future.ttf".freeze

  COLOR = {
    r: 51,
    g: 51,
    b: 51,
    a: 255
  }.freeze

  def font
    FONT
  end

  def color
    COLOR
  end
end
