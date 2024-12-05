library ieee;
use ieee.std_logic_1164.all;

entity DR is
 
    port (d0  : in  std_logic ;
    
          clk : in  std_logic;
          Res : in  std_logic;
          
          q   : out std_logic );
end DR;

architecture D of DR is
begin
     state : process(clk,Res)
    begin
    if rising_edge(clk) then
      if Res =  '0' then
                  
	         q <= '0';--(others => '0');
        else
 
                q <= d0;
        end if; 
       end if;
    end process;

end architecture D;
