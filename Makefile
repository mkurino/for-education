#
#	Makefile.004
#
#	変数は自分増やせる
#
#	特別な変数(一文字変数)
#		@	target
#		<	sources
#
#	継続行
#		行末(改行の直前)の「\」は、継続行を表す

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
# メタな生成規則
#

.SUFFIXES:	.f95

.f95.o	:
	gfortran -c $<

# は、「centrifugal_potential_idogata.o をつくれ」といわれると、
#	#	centrifugal_potential_idogata.o	:	centrifugal_potential_idogata.f95
#	#		gfortran -c $<
# と同じなる.
# さらに、< という変数は、soruce 並びにかきかわるので
#	#	centrifugal_potential_idogata.o	:	centrifugal_potential_idogata.f95
#	#		gfortran -c centrifugal_potential_idogata.f95
# となる

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

