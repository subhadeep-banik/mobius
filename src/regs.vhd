library ieee;
use ieee.std_logic_1164.all;

entity RegScan is
    generic (N : integer := 256);
    port (d0  : in  std_logic_vector(0 to N-1);
    	  d1  : in  std_logic_vector(0 to N-1);
    	  sel : in  std_logic;
          clk : in  std_logic;
 
          
          q   : out std_logic_vector(0 to N-1));
end RegScan;

architecture structural of RegScan is
begin
     state : process(clk,sel)
    begin
    if  rising_edge(clk) then
     if sel = '0' then 
                q <= d0;
     else
                q <= d1;
     end if;            
    end if; 
    end process;

end architecture structural;
