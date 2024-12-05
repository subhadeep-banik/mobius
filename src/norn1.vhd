library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
--use work.mob_pkg.all;
--use work.eq_pkg.all;
use work.all;

entity norn1 is 
	generic ( w	: integer := 256 );	
	
	port (
		-- inputs
 
		din:		in std_logic_vector (0 to w-1);
		
		-- outputs
		data_out: 	out std_logic_vector (0 to w-1)
	);
end norn1;

architecture rtl of norn1 is

--signal int: integer range 0 to 2**(w+1)-1;
signal sig: std_logic_vector (0 to w);
signal tsig: std_logic_vector (0 to w-1);
signal dinr :std_logic_vector (0 to w-1);
function log2ceil (L: integer) return integer  is
    variable i : integer ;
begin

     i := 0;  
      while (2**i < L) and i < 31 loop
         i := i + 1;
      end loop;
      return i;
end log2ceil;
begin 

--	 q: for i in 0 to w-1 generate 
--	 dinr(i)<= din(w-1-i);
--	 end generate q;

 
	--e: entity incrementer (behav)
	--generic map (w,8)
	--port map (dinr,tsig);
	
	e: entity ppa (brentkung)
	 generic map (log2ceil(w))
	 port map (din ,tsig);
	
	
	
	r: for i in 0 to w-1 generate 
	--data_out(w-1-i) <= din(i) or tsig(i);
		data_out(i) <= din(i) or tsig(i);
	end generate r;

 
         

end rtl;
