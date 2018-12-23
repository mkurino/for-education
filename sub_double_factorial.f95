

function double_factorial(l) result(value)


	implicit none
	
	integer value 
	
	integer l
	integer n
	
	integer i
	integer j
	
	value=1
	
!	read(*,*) l


	if (l==0) then 
		value=1
		
	else if (mod(l,2)==1) then
		
		n=(l+1)/2
		
		do i=1,n
			value=(2*i-1)*value
		enddo
		
	else if (mod(l,2)==0) then
		n=l/2
		
		do i=1,n
			 value=(i*2)*value
		enddo
		
		value=value*(2**n)
	endif

!	write(*,*) value




end function double_factorial




