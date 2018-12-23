

function centrifugal_idogata_potential (r,depth) result (value)
	implicit none
	include "constant.include"

	double precision value
	double precision r
	double precision depth
	!関数の引数と結果
	!depthはポテンシャルの深さを決定
	!引力の時は負、斥力の場合は正にとる
	!つまりポテンシャルの原点は井戸の底ではなく井戸の口
	
!	double precision h

	integer ang_momentum
	
	
!	integer dir

	
	double precision length 
		!井戸型ポテンシャルの存在領域を決定する
		
!	h=10.0/1024.0
	
	ang_momentum=0
	!一応この値を動かせば遠心力を含んだポテンシャルにできるが、今は0で固定してあるため実質遠心力は0
	
!	length = 5.0
		!後で好きに変えろ。スケールはfmとする予定
		!必ず正の値が入る
	
	if (0<r .and. r<2.1) then
		value = depth+ang_momentum*(ang_momentum+1)/(r**2.0)
		
	else
		value=ang_momentum*(ang_momentum+1)/(r**2.0)
	
	endif	
	
	


end function centrifugal_idogata_potential

