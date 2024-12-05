library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity PEs is 
generic(v: integer := 4);
         
port ( Inp:         in std_logic_vector(0 to 2**v-1); 
       Oup:          out std_logic_vector(v-1 downto 0);
       Val:          out std_logic);
end entity PEs;


architecture enc of PEs is

signal counts: integer range 0 to 2**v-1;
    constant allone: std_logic_vector(0 to 2**v-1) := (others =>'1' ) ;
begin 


Val <= '0' when Inp = allone else '1';

behav: process (Inp)

  
	variable count:	integer range 0 to 2**v-1;

begin 
count:=0;
a1: for i in 2**v-1 downto 0 loop
      if Inp(i)='0' then 
         count:= i;
       end if;
end loop a1;


counts<=count;
end process behav;


Oup <= std_logic_vector(to_unsigned(counts, v));

end architecture enc;
