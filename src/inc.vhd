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

architecture rtl of incrementer is 

signal g: std_logic_vector(0 to len-1);

begin 

 

ass: for i in 0 to len-2 generate
g(i)<='0';
end generate ass;
g(len-1)<='1';

  
  
dd: entity block_adder  
generic map ( len,w )
  port map ( a,g,s );
 




end architecture rtl;
