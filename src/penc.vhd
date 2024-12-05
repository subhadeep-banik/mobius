library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity PEnc is 
generic(n: integer := 8;
        k: integer := 4);
         
port ( Inp:         in std_logic_vector(0 to 2**n-1); 
      -- Clk:	     in std_logic;
       Oup:          out std_logic_vector(n-1 downto 0);
       Val:          out std_logic);
end entity PEnc;

architecture enc of PEnc is

type PEtype is array (0 to 2**k-1) of std_logic_vector(n-k-1 downto 0);
signal Op: PEtype;

signal v,u:  std_logic_vector(0 to 2**k-1);

signal S: integer range 0 to 2**k-1;
signal SEL: std_logic_vector(k-1 downto 0);


begin 


row: for i in 0 to 2**k-1 generate 


   es: entity PEs (enc) generic map (n-k)
                        port map (Inp(i*2**(n-k) to (i+1)*2**(n-k) -1 ), Op(i), v(i));

u(i) <= not v(i);
end generate row; 


r2: entity PEs (enc) generic map (k)
                        port map (u, SEL , Val);

S<= to_integer(unsigned(SEL));

Oup <= SEL & Op(S);

end architecture enc;


