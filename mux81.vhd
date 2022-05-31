-- includerea bibliotecii std_logic din ieee
library ieee;
use ieee.std_logic_1164.all;

-- entitatea multiplexorului 8:1
entity mux81 is
    port (
        d   : in  std_logic_vector(0 to 7);
        sel : in  std_logic_vector(0 to 2);
        o   : out std_logic
    );
end entity mux81;

-- arhitectura multiplexorului 8:1
architecture rtl of mux81 is
begin
    process(d, sel)
    begin
        -- tratarea cazurilor pentru intrarile de selectie
        case sel is
            when "000"  => o <= d(0);
            when "001"  => o <= d(1);
            when "010"  => o <= d(2);
            when "011"  => o <= d(3);
            when "100"  => o <= d(4);
            when "101"  => o <= d(5);
            when "110"  => o <= d(6);
            when "111"  => o <= d(7);
            when others => o <= '0';
        end case;
    end process;
end architecture rtl;
