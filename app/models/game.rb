class Game
  attr_reader :error_message, :frame_number, :frame

  FRAMES = 10
  PINS   = 10

  def initialize(params, frame)
    @frame = frame.nil? ? [nil] : frame
    @ball1 = params[:ball1].to_i if params[:ball1]
    @ball2 = params[:ball2].to_i if params[:ball2]
    @ball3 = params[:ball3].to_i if params[:ball3]
    frame_number
  end

  def frame_number
    @frame_number ||= valid? ? frame.size : frame.size - 1
  end

  def calc
    @frame[frame_number] = {spare: spare?, strike: strike?, score: calc_frame_score}
  end

  def total
    @frame.inject(0){|rez, item| item ? rez + item[:score] : rez }
  end

  def over?
    frame_number >= FRAMES + (frame_number == FRAMES && (strike? || spare?)  ? 1 : 0)
  end

  def strike?
    @ball1 == PINS
  end

  def spare?
    @ball1 + @ball2 == PINS
  end

  def valid?
    @valid ||= begin
      @error_message = ''
      if !@ball1 || !in_range(@ball1)
        @error_message = 'The 1st ball knocked wrong number of pins'
        return
      end
      if (!strike? && !@ball2) || !in_range(@ball2)
        @error_message = 'The 2nd ball knocked wrong number of pins'
        return
      end
      if !strike? && !in_range(@ball1 + @ball2)
        @error_message = 'The sum of knocked pins is wrong'
        return
      end
      true
    end
  end

  private
  def calc_frame_score
    prev_frame = frame[frame_number - 1]
    if prev_frame && (prev_frame[:strike] || prev_frame[:spare])
      frame[frame_number - 1][:score] = PINS + @ball1 + (prev_frame[:strike] ? @ball2 : 0)
    end
    @ball1 + @ball2
  end

  def in_range(num)
    (0..PINS) === num
  end

end