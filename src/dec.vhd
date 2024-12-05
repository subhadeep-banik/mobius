library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity decoder is 
	generic ( w	: integer := 4 );	
	
	port (
		-- inputs
 
		din:		in std_logic_vector (w-1 downto 0);
		
		-- outputs
		data_out: 	out std_logic_vector (0 to 2**w-1)
	);
end decoder;

architecture rtl of decoder is

begin 

	demux_pr: process(din)
	begin
		-- set all the outputs to '0' to avoid inferred latches
		data_out <= (others => '0');
		-- Set input in correct line
		data_out(to_integer(unsigned(din))) <= '1';
	end process;

end rtl;
