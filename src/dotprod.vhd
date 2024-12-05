library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity dotprod is 
generic(m: integer:=8);
        
  port (inp1 :           in std_logic_vector(0 to  m-1); 
        inp2 :           in std_logic_vector(0 to  m-1); 
        oup :            out std_logic );
        
        
end entity dotprod;


architecture dp of dotprod is 


type treetype is array (0 to log2ceil(m), 0 to 2**(log2ceil(m)) ) of std_logic ; 
signal C: treetype;

begin



-------------------------------------------------------------------
--xor network
-------------------------------------------------------------------
a21: for i in 0 to (m)-1 generate
	C(0,i) <= inp1(i) and inp2(i);
end generate a21;  
a22: for i in m to 2**(log2ceil(m)) generate
	C(0,i) <=  '0' ;
end generate a22;  



 
tree1: for t in 1 to log2ceil(m) generate 

  level1: for l in 0 to (2**(log2ceil(m) - t )) -1 generate 
         C(t,l) <= C(t-1,2*l) xor  C(t-1,2*l+1);
  end generate level1;
end generate tree1;  


oup<= C(log2ceil(m),0);

end architecture dp;


