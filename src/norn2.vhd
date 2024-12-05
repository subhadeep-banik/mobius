library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
--use work.mob_pkg.all;
--use work.eq_pkg.all;
use work.all;

entity norn1 is 
	generic ( w	: integer := 8 );	
	
	port (
		-- inputs
 
		din:		in std_logic_vector (0 to 2**w-1);
		
		-- outputs
		data_out: 	out std_logic_vector (0 to 2**w-1)
	);
end norn1;

architecture rtl of norn1 is

--signal int: integer range 0 to 2**(w+1)-1;
signal sig: std_logic_vector (0 to 2**w);
signal tsig: std_logic_vector (0 to 2**w-1);
signal dinr :std_logic_vector (0 to 2**w-1);
 
begin 

	 q: for i in 0 to 2**w-1 generate 
	 dinr(i)<= din(2**w-1-i);
	 end generate q;

 
	--int<= to_integer(1+unsigned(dinr));
	e: entity incrementer (behav)
      generic map (2**w,2**(w/2))
	port map (dinr,tsig);
	--e: entity incrementer (ks)
	--generic map (w)
	--port map (dinr,tsig);
	
	--sig  <=  std_logic_vector(to_unsigned(int, w+1));
	--tsig <= sig(1 to w);
	
	
	r: for i in 0 to 2**w-1 generate 
	data_out(2**w-1-i) <= dinr(i) or tsig(i);
	end generate r;

 
         

end rtl;
