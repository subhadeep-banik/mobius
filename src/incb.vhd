library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity incrementer is
  generic ( len: integer := 256;
            w: integer :=   16
   );	
  port(
        a: in std_logic_vector(0 to len-1);
        s: out std_logic_vector(0 to len-1)
      );
end;

architecture behav of incrementer is 

 
signal  as, cs,ds:   unsigned(0 to len-1);
signal  c:std_logic_vector(0 to len-1);
begin 

--ass: for i in 0 to len-2 generate
--c(i)<='0';-
--end generate ass;
--c(len-1)<='1';

 
as <= unsigned(a);
--cs <= unsigned(c);

ds <= as+1;---cs;
 
s <= std_logic_vector(ds(0 to len-1));


end architecture behav;





