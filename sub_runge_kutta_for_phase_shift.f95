!================================================================================

!ルンゲクッタを実行するサブルーチン
!初期の波数とポテンシャルと角運動量を受け取り、波動関数を求めるのが仕事
!位相差を求めるために、十分遠方での波動関数の値が必要になるため、その値をメインに返してくれるように設計する。
!また、位相差を求めることに特化しているため、ルンゲクッタの始点は必ず0から始める
!漸近形はリカッチベッセル関数を用いて与える
!すなわちこのアルゴリズムで求まる解はRegular_SolutionのWavefunctionである

!ポテンシャルは別の場所で用意する
!微分方程式を解くための手法はルンゲクッタ法
!得られた解をriccatibesselと比較することによってfaseshiftを求める。
!散乱問題を解く、とはここではフェイズシフトを求めることを指す


!===============================================================================
subroutine runge_kutta_for_phase_shift(momentum,l,distant_wave_func,distant_div_wave_func)
	implicit none
	include "constant.include"
!=================================================================================
!以下変数の定義
!	integer a(10,10)
	
!	integer,parameter ::step_number=2000
!	integer,parameter ::angular_momentum=20
	
	integer i,j,k
		! ループ用の引数
	integer intbox
		!都合のいい箱、何を入れてもいい
	double precision realbox
		!都合のいい箱
	integer n 
		! 変数を離散にするための変数
!	double precision h
		! 離散化させたときの幅
	double precision f
		!初期値設定用の幅	
	double precision momentum
		! 初期エネルギーであり、実験者が勝手に与えてよい定数。波数として扱う
	integer l
		! 角運動量。0以上の整数値を取る。多分10くらいまで求めれば十分
	double precision r(0:step_number+1)
		! 座標。後でrの関数を書くために、値を残しておかないといけない。
	
	double precision y(0:step_number+1,0:angular_momentum+1)
		! 求めたい関数。rの関数であるため、lとnで値が決まる。
		
	double precision z(0:step_number+1,0:angular_momentum+1)
		! yの1回微分。やはりn,lでパラメタライズされる。
	
!	double precision potential
		! ポテンシャル
		!多分関数として定義する	
	double precision centrifugal_idogata_potential
	double precision rungekutta
		!l,n,k,r,y,zの関数。potentialにも依存するメインの関数。
		!functionで定義が必要だと思うけど忘れた
		!本来zに依存するが、微分方程式が一回の微分を含まないため、zには依存しない。
		!n依存性ではなくr依存性で考えることにする
		
	double precision p(4)
	double precision q(4)
		! ルンゲクッタ用のパラメータ
		!四次以上のルンゲクッタ方に適用したい場合は頑張って拡張しろ
	
	integer double_factorial
	
	double precision distant_wave_func
	double precision distant_div_wave_func
	double precision depth
	
		
!ここまでは変数の定義		
!========================================================================
!以下変数の初期値設定	
!	h=0.01
!include文の中に初期値が入っているので変えたかったらそこを参照しろ
	n=0
	l=0
	depth =(-33.7/197.33)*(940.0/197.33)

	r(0)=0.000001
!	do l=0,angular_momentum
		y(0,l)=((momentum*r(0))**(l+1))/double_factorial(l+1)
		z(0,l)=momentum*(l+1)*((momentum*r(0))**(l))/double_factorial(l+1)

!	enddo
	!l=0の時しか取り合えず作らないけど、後でlが自由に動けるように改良する予定
!	momentum=1000

	f=h-r(0)
!	do l=0,angular_momentum
		
		p(1)=f*z(0,l)
		q(1)=f*rungekutta(r(0),l,momentum,y(0,l),centrifugal_idogata_potential(r(n),depth))
		p(2)=f*(z(0,l)+q(1)/2)
		q(2)=f*rungekutta(r(0)+f/2.0,l,momentum,y(0,l)+p(1)/2.0,centrifugal_idogata_potential(r(n),depth))
		p(3)=f*(z(0,l)+q(2)/2)
		q(3)=f*rungekutta(r(0)+f/2.0,l,momentum,y(0,l)+p(2)/2.0,centrifugal_idogata_potential(r(n),depth))
		p(4)=f*(z(0,l)+q(3))
		q(4)=f*rungekutta(r(0)+f,l,momentum,y(0,l)+p(3),centrifugal_idogata_potential(r(n),depth))
	
	
		y(1,l)=y(0,l)+(p(1)+2.0*p(2)+2.0*p(3)+p(4))/6.0
		z(1,l)=z(0,l)+(q(1)+2.0*q(2)+2.0*q(3)+q(4))/6.0
!	enddo
	!始点の値を原点(0)としてしまうと、恒久的に0になってしまう場合があるため、微小なr(0)から始めている。
	!更にそこから幅hでループをまわすために、上記のように幅fでルンゲクッタを1回まわして、幅hに合わせている
		l=0
!ここまで変数の初期値設定		
!=================================================================================	
!以下rungekutta方にかかわるメイン部分
! n がどこまで動くといい感じになるのかはよくわからない
!全体的に次元はわかっても単位がわかってないため、距離とかエネルギーの基準がよくわからない
!rungekuttaf (r,l,momentum,y) の引数の順番は注意。といってもmomentumとlは変わらん
!	do l=0,10
!今はl=0で固定する
		do n=1,step_number
		
			r(n)=n*h
			p(1)=h*z(n,l)
			q(1)=h*rungekutta(r(n),l,momentum,y(n,l),centrifugal_idogata_potential(r(n),depth))
			p(2)=h*(z(n,l)+q(1)/2.0)
			q(2)=h*rungekutta(r(n)+h/2.0,l,momentum,y(n,l)+p(1)/2.0,centrifugal_idogata_potential(r(n),depth))
			p(3)=h*(z(n,l)+q(2)/2.0)
			q(3)=h*rungekutta(r(n)+h/2.0,l,momentum,y(n,l)+p(2)/2.0,centrifugal_idogata_potential(r(n),depth))
			p(4)=h*(z(n,l)+q(3))
			q(4)=h*rungekutta(r(n)+h,l,momentum,y(n,l)+p(3),centrifugal_idogata_potential(r(n),depth))
		
			y(n+1,l)=y(n,l)+(p(1)+2.0*p(2)+2.0*p(3)+p(4))/6.0
			z(n+1,l)=z(n,l)+(q(1)+2.0*q(2)+2.0*q(3)+q(4))/6.0
		enddo
!	enddo
	
	!以下では、位相差を求めるためにメインにdistant_weve_functionを渡すための作業を行う
	
	l=0
	distant_wave_func=y(step_number,0)
	distant_div_wave_func= z(step_number,0)
	!ここでは角運動量を0としている
	!つまり折角上で一般化されている角運動量の値は現状意味がない
	

end subroutine 

!ここまでメインプログラム
!====================================================================================
! 以下サブルーチンとか関数の定義とか
!後で分離すべし


!function potential (r) result (value)
!	implicit none
!	integer n
	
!	double precision value
!	double precision h
!	double precision r
!	double precision a
	
	
!	a=1
	
	
	
!	value=0
	
!	value=exp(-a(r^2))
	
	
	
!end function potential
!ポテンシャルを決めている関数。
!今回はガウシアンを採用するが、aについては後で指定できるようにしたい。



function rungekutta (r,l,momentum,y,potential) result (value)
	
	implicit none
	integer l
	
	
	double precision value
	double precision potential
	
	double precision momentum
	double precision h
	double precision r
	double precision y
	
!	if (n==0) then
!		value=0
!	else	
		value=((l*(l+1)/(r**2.0))+potential-momentum**2.0)*y
!	endif

!0除算が怖いので場合分けしてある

end function rungekutta








!subroutine sub(a) 

!	integer a(1)
	
!	integer i,j
	
!	do i=1,10
!		do j=1,10
!			write(*,*) i,j,a(10*(j-1)+i)
!		enddo
!	enddo



!end subroutine
!do並びで検索


!	do i=1,10
!		do j=1,10
!			a(i,j)=i*1000+j
!		enddo
!	enddo
	
	
	
!	call sub(a)




