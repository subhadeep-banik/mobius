library ieee;
use ieee.std_logic_1164.all;

entity RegR is
    generic (N : integer := 256);
    port (d0  : in  std_logic_vector((N - 1) downto 0);
    
          clk : in  std_logic;
          Res : in  std_logic;
          
          q   : out std_logic_vector((N - 1) downto 0));
end RegR;

architecture structural of RegR is
begin
     state : process(clk,Res)
    begin
    if Res =  '0' then
                  
	         q <= (others => '0');
        elsif rising_edge(clk) then
 
                q <= d0;
        end if; 
    end process;

end architecture structural;
