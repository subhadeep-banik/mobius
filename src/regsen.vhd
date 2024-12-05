library ieee;
use ieee.std_logic_1164.all;

entity RegScanEN is
    generic (N : integer := 256);
    port (d0  : in  std_logic_vector(0 to N-1);
    	  d1  : in  std_logic_vector(0 to N-1);
    	  sel : in  std_logic;
     	  en  : in  std_logic;   	  
          clk : in  std_logic;
 
          
          q   : out std_logic_vector(0 to N-1));
end RegScanEN;

architecture structural of RegScanEN is
begin
     state : process(clk,sel,en)
    begin
    if en ='0' then 
    NULL;
    
    elsif  rising_edge(clk) then
     if sel = '0' then 
                q <= d0;
     else
                q <= d1;
     end if;            
    end if; 
    end process;

end architecture structural;
