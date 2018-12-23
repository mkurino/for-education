
program obtain_phase_shift

implicit none
include "constant.include"
!S波のfaseshiftを得るためのプログラム。つまりδが欲しい
!ついでに複素数の変数を扱う練習をする
!位相差の２piをどうするかが問題となる
!=============================================================================================================
!以下変数の定義
	
	integer,parameter ::phase_shift_parameter=100


	double precision momentum(0:phase_shift_parameter+1)
	integer l
	integer i,j,k
!	integer step_number


	double precision potential


	double precision distant_wave_func
	double precision distant_div_wave_func
	!サブルーチンで計算した遠方での波動関数の値
	
	
	double precision centrifugal_idogata_potential
	!遠心力を含む井戸型ポテンシャルなんだけど、いま遠心力が0なので実質ただの井戸型

	double precision tmp_wf(0:phase_shift_parameter+1)
	double precision tmp_div_wf(0:phase_shift_parameter+1)
	!サブルーチンの計算結果を受け取るための箱
	
	double precision tmp_riccati_bessel
	double precision tmp_riccati_neumann

	double precision r(0:step_number+1)
	!横軸r
!	double precision h
	! 刻み幅
	!初期値はinclude分の中に居る	
	
!	double precision pi
	!いわゆる円周率
	
	double precision t_phase_shift(0:phase_shift_parameter+1)
	!タンジェントδのこと
	!今回は角運動量は0と思っていいことにする
	!こいつの逆関数を求めるのが第一目標
	
	double precision phase_shift(0:phase_shift_parameter+1)	
	!こいつが目標1
	
	double precision effective_range_formula(0:phase_shift_parameter+1)
		!kcotδの値を格納する箱
	double precision scattering_length
		!aって書かれてる奴
	double precision effective_range(0:phase_shift_parameter+1)
		!r_eって書かれてる奴
		!運動量によらず一定だが、其の検証の為に全ての運動量について求めるため配列にする
!=============================================================================================================
!以下初期値の定義
	
!	read(*,*) momentum(1)
!	read(*,*) l

	l=0	
!S波の散乱状態を知りたいので今lは0で固定しておく	
	
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



	!リカッチベッセル関数の無限遠での漸近形を作る
	!漸近形は早く覚えろ甘えるな
	
!=============================================================================================================
!以下メインプログラム

!	write(*,*) momentum(1)

	do i=0,phase_shift_parameter
		l=0
		tmp_riccati_bessel= sin(momentum(i)*r(step_number)-l*pi/2)
		tmp_riccati_neumann=cos(momentum(i)*r(step_number)-l*pi/2)
!			write(*,*) tmp_riccati_bessel
!			write(*,*) tmp_riccati_neumann

		call runge_kutta_for_phase_shift(momentum(i),l,distant_wave_func,distant_div_wave_func)
		!ここでdistant_wave_funcの値を得る
	
		tmp_wf(i)=distant_wave_func
		tmp_div_wf(i)=distant_div_wave_func/momentum(i)
!			write(*,*) tmp_wf(i)
!			write(*,*) tmp_div_wf(i)
			
			!ここでサブルーチンで計算した遠方での波動関数の値を受け取っている
	
		t_phase_shift(i)=(tmp_wf(i)*tmp_riccati_neumann-tmp_div_wf(i)*tmp_riccati_bessel)
!			write(*,*) t_phase_shift(i)
		t_phase_shift(i)=t_phase_shift(i)/(tmp_wf(i)*tmp_riccati_bessel+tmp_div_wf(i)*tmp_riccati_neumann)
			!長くなったので二分割で計算。しかし分子分母が0に収束する時が心配
!			write(*,*) t_phase_shift(i)
		
		phase_shift(i)=atan(t_phase_shift(i))
			!こいつは有効距離理論においては求める必要はない
			!しかしこいつの値によっては場合わけが必要になるためやはり計算しておくのが無難
		
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
	!値チェック用のデバックwrite

!	do i=1,	phase_shift_parameter
!		write(*,*) momentum(i),',',phase_shift(i)
!	enddo
end program
!=============================================================================================================
!以下サブルーチンとか不採用となったコード


