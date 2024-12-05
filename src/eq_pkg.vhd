library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mob_pkg.all;
package eq_pkg is

    type eq_array is array(natural range <>) of std_logic_vector;
    function log2ceil (L : integer) return integer;
end package;

package body eq_pkg is

function log2ceil (L: integer) return integer  is
    variable i : integer ;
begin

     i := 0;  
      while (2**i <= L) and i < 31 loop
         i := i + 1;
      end loop;
      return i;
end log2ceil;

end package body;
