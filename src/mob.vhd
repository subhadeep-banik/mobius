library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity Mob is 
generic(N: integer := 64;
        v: integer := 6);
         
port ( ANF:         in std_logic_vector(0 to N-1); 
     --  Clk:         in std_logic; 
       
       CT:          out std_logic_vector(0 to N-1));
end entity Mob;


architecture mymob of Mob is
 
type Sigtype is array (0 to v) of std_logic_vector(0 to N-1); 
 
signal s: Sigtype;
 
 
 
function flip (
	 a: 	integer;
	 b:	integer
	) return integer is
		variable tmp  : integer;
		variable c  : integer;		
	begin
		tmp :=  2**b;
		c := a + tmp;
		return c;
	end function flip;
	
	
function insert (
	 a: 	integer;
	 b:	integer
	) return integer is
	        variable p : integer;
		variable d : integer;
		variable c : integer;
		variable e : integer;				
	begin
                p := 2**b;
		c := a / p;
		d := a mod p;
		e := 2*c*p +d ;
		return e;
	end function insert;
		

	
	 
begin

 
s(0)<=ANF;


a1: for i in  0 to v-1 generate 

         
  b1: for j in  0 to ((N/2) -1) generate 
     
    s(i+1)(flip( insert(j,i) ,  i )) <= s(i)(flip( insert(j,i), i) ) xor s(i)( insert(j,i) ) ;
    s(i+1)( insert(j,i) )  <=  s(i)( insert(j,i) )  ;

     end generate b1;

end generate a1;

CT <= s(v);





end architecture mymob;
