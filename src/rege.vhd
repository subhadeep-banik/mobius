library ieee;
use ieee.std_logic_1164.all;

entity RegE is
    generic (N : integer := 256);
    port (d0  : in  std_logic_vector((N - 1) downto 0);
          en  : in  std_logic;
          clk : in  std_logic;
 
          
          q   : out std_logic_vector((N - 1) downto 0));
end RegE;

architecture structural of RegE is
begin
     state : process(clk,en)
    begin
     if en ='0' then 
        NULL;
        elsif rising_edge(clk) then
 
                q <= d0;
         end if;
    end process;

end architecture structural;
