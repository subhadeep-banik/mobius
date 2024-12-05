library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity SS is 
 
 
	port (
		-- inputs
 
		Res:		in std_logic ;
		Clk:		in std_logic ;
		eoct: in std_logic ;
		 
		-- outputs
		start: 	out std_logic 
	); 
end SS;

architecture E of SS is

 --type Cttype is array (0 to (h)-1) of unsigned(v-h+1 downto 0) ;  
signal  start_n,s: std_logic; 
 
begin 


   start <=s;
  
	demux_pr: process(all)
	begin
	  if Res='0' then
	           s <='1';
	         
                   
	    elsif Clk'event and Clk  ='1' then
	            
		   s <=start_n;
		    
	   end if;
	end process;
	
 
 start_n<= '0' when eoct='1' else s;  
  

end E;
