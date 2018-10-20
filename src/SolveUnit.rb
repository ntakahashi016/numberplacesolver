# coding: cp932
class SolveUnit

  def intialize(unfixed_numbers)
    @cells = []
    @unfixed_numbers = unfixed_numbers
  end

  # �Q�Ƃ��Ă���Cell�ɍX�V�����������Ƃ̒ʒm
  def notify()
    # ���łɂ��ׂĂ̐������m�肵�Ă���ꍇ��������
    if !self.is_fixed?
      # s6tep 1 �m�肵�Ă��鐔�����m�F��@unfixed_numbers���X�V����
      fixed_numbers = [] # ����V���Ɋm�肵���������L�^���Ă���
      @cells.each do |cell|
        if !cell.is_blank?
          # �������m�肵�Ă���Cell�̂ݑΏۂƂ���
          number = cell.number
          if @unfixed_numbers.include?(number)
            # ���m�肾�����������m�肵�Ă����ꍇ
            @unfixed_numbers.del_number(number)
            fixed_numbers.add(number)
          end
        end
      end
      # step 2 ��cell�̌�₩��m�肵�����������O����
      if fixed_numbers != [] # ����V���Ɋm�肵���������Ȃ������疳������
        @cells.each do |cell|
          if cell.is_blank?
            # �������m�肵�Ă��Ȃ�Cell�̂ݑΏۂƂ���
            fixed_numbers.each do |number|
              cell.del_candidate(number)
            end
          end
        end
      end
    end
  end

  def is_fixed?()
    @unfixed_numbers.is_blank?
  end

  def get_unfixed_numbers()
    @get_unfixed_numbers
  end

end
