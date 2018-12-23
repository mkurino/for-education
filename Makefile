#
#	Makefile.005
#
#	GitHub の機能を追加
#

#F95	=	centrifugal_potential_idogata.f95	\
#		obtain_phase_shift.f95	\
#		sub_double_factorial.f95	\
#		sub_runge_kutta_for_phase_shift.f95

F95	=	${wildcard:*.f95}
OBJ	=	$(F95:.f95=.o)
CSV	=	${wildcard:*.csv}

#
#
#

COMMIT_FILES	=	${F95} Makefile ${CSV} README.md

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

#
#	GitHub 関係の操作
#		変数「?」は、sources の中で target より新しいファイルだけに置き換わる
#

pull	:
	git pull origin master

push	:	${COMMIT_FILES}
	git add $?
	git commit -m "`LANG=C date`"
	git push origin master
	touch push




