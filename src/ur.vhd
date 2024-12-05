library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
 
use work.all;

entity UR is
    generic (N : integer := 256);
    port (d0  : in   unsigned(N-1 downto 0) ;
    
          clk : in  std_logic;
          Res : in  std_logic;
          
          q   : out unsigned(N-1 downto 0));
end UR;

architecture D of UR is
begin
     state : process(clk,Res)
    begin
    if rising_edge(clk) then
    if Res =  '0' then
                  
	         q <=  to_unsigned(0,N);
        else
 
                 q <= d0;
        end if; 
        end if;
    end process;

end architecture D;
