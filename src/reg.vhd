library ieee;
use ieee.std_logic_1164.all;

entity Reg is
    generic (N : integer := 256);
    port (d0  : in  std_logic_vector((N - 1) downto 0);
    
          clk : in  std_logic;
 
          
          q   : out std_logic_vector((N - 1) downto 0));
end Reg;

architecture structural of Reg is
begin
     state : process(clk)
    begin
        if rising_edge(clk) then
 
                q <= d0;
         end if;
    end process;

end architecture structural;
