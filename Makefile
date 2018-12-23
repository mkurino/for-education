#
#	Makefile.004
#
#	�ϐ��͎������₹��
#
#	���ʂȕϐ�(�ꕶ���ϐ�)
#		@	target
#		<	sources
#
#	�p���s
#		�s��(���s�̒��O)�́u\�v�́A�p���s��\��

F95	=	centrifugal_potential_idogata.f95	\
		obtain_phase_shift.f95	\
		sub_double_factorial.f95	\
		sub_runge_kutta_for_phase_shift.f95

OBJ	=	$(F95:.f95=.o)

#
#
#

all	:	a.exe

#
#
#

a.exe	:	$(OBJ)
	gfortran -o $@ $<

#
# ���^�Ȑ����K��
#

.SUFFIXES:	.f95

.f95.o	:
	gfortran -c $<

# �́A�ucentrifugal_potential_idogata.o ������v�Ƃ�����ƁA
#	#	centrifugal_potential_idogata.o	:	centrifugal_potential_idogata.f95
#	#		gfortran -c $<
# �Ɠ����Ȃ�.
# ����ɁA< �Ƃ����ϐ��́Asoruce ���тɂ��������̂�
#	#	centrifugal_potential_idogata.o	:	centrifugal_potential_idogata.f95
#	#		gfortran -c centrifugal_potential_idogata.f95
# �ƂȂ�

#centrifugal_potential_idogata.o	:	centrifugal_potential_idogata.f95
#	gfortran -c centrifugal_potential_idogata.f95

#obtain_phase_shift.o	:	obtain_phase_shift.f95
#	gfortran -c obtain_phase_shift.f95

#sub_double_factorial.o	:	sub_double_factorial.f95
#	gfortran -c sub_double_factorial.f95

#sub_runge_kutta_for_phase_shift.o	:	sub_runge_kutta_for_phase_shift.f95
#	gfortran -c sub_runge_kutta_for_phase_shift.f95

clean	:
	rm a.exe
	rm $(OBJ)
#	touch clean

