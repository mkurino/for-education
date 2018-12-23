

function centrifugal_idogata_potential (r,depth) result (value)
	implicit none
	include "constant.include"

	double precision value
	double precision r
	double precision depth
	!�֐��̈����ƌ���
	!depth�̓|�e���V�����̐[��������
	!���͂̎��͕��A�˗͂̏ꍇ�͐��ɂƂ�
	!�܂�|�e���V�����̌��_�͈�˂̒�ł͂Ȃ���˂̌�
	
!	double precision h

	integer ang_momentum
	
	
!	integer dir

	
	double precision length 
		!��ˌ^�|�e���V�����̑��ݗ̈�����肷��
		
!	h=10.0/1024.0
	
	ang_momentum=0
	!�ꉞ���̒l�𓮂����Ή��S�͂��܂񂾃|�e���V�����ɂł��邪�A����0�ŌŒ肵�Ă��邽�ߎ������S�͂�0
	
!	length = 5.0
		!��ōD���ɕς���B�X�P�[����fm�Ƃ���\��
		!�K�����̒l������
	
	if (0<r .and. r<2.1) then
		value = depth+ang_momentum*(ang_momentum+1)/(r**2.0)
		
	else
		value=ang_momentum*(ang_momentum+1)/(r**2.0)
	
	endif	
	
	


end function centrifugal_idogata_potential

