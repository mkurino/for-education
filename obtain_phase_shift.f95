
program obtain_phase_shift

implicit none
include "constant.include"
!S�g��faseshift�𓾂邽�߂̃v���O�����B�܂���~����
!���łɕ��f���̕ϐ����������K������
!�ʑ����̂Qpi���ǂ����邩�����ƂȂ�
!=============================================================================================================
!�ȉ��ϐ��̒�`
	
	integer,parameter ::phase_shift_parameter=100


	double precision momentum(0:phase_shift_parameter+1)
	integer l
	integer i,j,k
!	integer step_number


	double precision potential


	double precision distant_wave_func
	double precision distant_div_wave_func
	!�T�u���[�`���Ōv�Z���������ł̔g���֐��̒l
	
	
	double precision centrifugal_idogata_potential
	!���S�͂��܂ވ�ˌ^�|�e���V�����Ȃ񂾂��ǁA���܉��S�͂�0�Ȃ̂Ŏ��������̈�ˌ^

	double precision tmp_wf(0:phase_shift_parameter+1)
	double precision tmp_div_wf(0:phase_shift_parameter+1)
	!�T�u���[�`���̌v�Z���ʂ��󂯎�邽�߂̔�
	
	double precision tmp_riccati_bessel
	double precision tmp_riccati_neumann

	double precision r(0:step_number+1)
	!����r
!	double precision h
	! ���ݕ�
	!�����l��include���̒��ɋ���	
	
!	double precision pi
	!������~����
	
	double precision t_phase_shift(0:phase_shift_parameter+1)
	!�^���W�F���g�̂���
	!����͊p�^���ʂ�0�Ǝv���Ă������Ƃɂ���
	!�����̋t�֐������߂�̂����ڕW
	
	double precision phase_shift(0:phase_shift_parameter+1)	
	!�������ڕW1
	
	double precision effective_range_formula(0:phase_shift_parameter+1)
		!kcot�̒l���i�[���锠
	double precision scattering_length
		!a���ď�����Ă�z
	double precision effective_range(0:phase_shift_parameter+1)
		!r_e���ď�����Ă�z
		!�^���ʂɂ�炸��肾���A���̌��؂ׂ̈ɑS�Ẳ^���ʂɂ��ċ��߂邽�ߔz��ɂ���
!=============================================================================================================
!�ȉ������l�̒�`
	
!	read(*,*) momentum(1)
!	read(*,*) l

	l=0	
!S�g�̎U����Ԃ�m�肽���̂ō�l��0�ŌŒ肵�Ă���	
	
	do i=0,step_number
		r(i)= h*i
	enddo
	
	momentum(0)=0.0000001
!	momentum(1)=0.0000001
!	momentum(2)=0.0000005
!	momentum(3)=0.000001
!	momentum(4)=0.0000015
!	momentum(5)=0.000002

	do i=1,phase_shift_parameter 
		momentum(i) = 0.01*i
	enddo	



	!���J�b�`�x�b�Z���֐��̖������ł̑Q�ߌ`�����
	!�Q�ߌ`�͑����o����Â����
	
!=============================================================================================================
!�ȉ����C���v���O����

!	write(*,*) momentum(1)

	do i=0,phase_shift_parameter
		l=0
		tmp_riccati_bessel= sin(momentum(i)*r(step_number)-l*pi/2)
		tmp_riccati_neumann=cos(momentum(i)*r(step_number)-l*pi/2)
!			write(*,*) tmp_riccati_bessel
!			write(*,*) tmp_riccati_neumann

		call runge_kutta_for_phase_shift(momentum(i),l,distant_wave_func,distant_div_wave_func)
		!������distant_wave_func�̒l�𓾂�
	
		tmp_wf(i)=distant_wave_func
		tmp_div_wf(i)=distant_div_wave_func/momentum(i)
!			write(*,*) tmp_wf(i)
!			write(*,*) tmp_div_wf(i)
			
			!�����ŃT�u���[�`���Ōv�Z���������ł̔g���֐��̒l���󂯎���Ă���
	
		t_phase_shift(i)=(tmp_wf(i)*tmp_riccati_neumann-tmp_div_wf(i)*tmp_riccati_bessel)
!			write(*,*) t_phase_shift(i)
		t_phase_shift(i)=t_phase_shift(i)/(tmp_wf(i)*tmp_riccati_bessel+tmp_div_wf(i)*tmp_riccati_neumann)
			!�����Ȃ����̂œ񕪊��Ōv�Z�B���������q���ꂪ0�Ɏ������鎞���S�z
!			write(*,*) t_phase_shift(i)
		
		phase_shift(i)=atan(t_phase_shift(i))
			!�����͗L���������_�ɂ����Ă͋��߂�K�v�͂Ȃ�
			!�����������̒l�ɂ���Ă͏ꍇ�킯���K�v�ɂȂ邽�߂�͂�v�Z���Ă����̂�����
		
		effective_range_formula(i)=momentum(i)/t_phase_shift(i)
	
	enddo

	scattering_length=(-1)/effective_range_formula(0)
	
	do i=1,phase_shift_parameter
		effective_range(i)=(effective_range_formula(i)+(1/scattering_length))*2/((momentum(i))**2)
	enddo
	
	do i=1, phase_shift_parameter
		if (phase_shift(i)<0) then
			phase_shift(i)=phase_shift(i)+3.14159265359
		endif
	enddo
	
	
	do i=1,phase_shift_parameter
		write(*,*) momentum(i),',',effective_range_formula(i),',',phase_shift(i),',',effective_range(i)
	enddo 
	!�l�`�F�b�N�p�̃f�o�b�Nwrite

!	do i=1,	phase_shift_parameter
!		write(*,*) momentum(i),',',phase_shift(i)
!	enddo
end program
!=============================================================================================================
!�ȉ��T�u���[�`���Ƃ��s�̗p�ƂȂ����R�[�h


