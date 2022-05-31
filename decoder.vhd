-- includerea bibliotecii std_logic din ieee
library ieee;
use ieee.std_logic_1164.all;

-- entitatea decodificatorului
entity decoder is
    port (
        c : in  std_logic_vector(3 downto 0);
        s : out std_logic_vector(0 to 9)
    );
end entity decoder;

-- arhitectura rtl a decodificatorului
architecture rtl of decoder is
begin
    s(0) <= not c(3) and not c(2) and not c(1) and not c(0);
    s(1) <= not c(3) and not c(2) and not c(1) and c(0);
    s(2) <= not c(3) and not c(2) and c(1) and not c(0);
    s(3) <= not c(3) and not c(2) and c(1) and c(0);
    s(4) <= not c(3) and c(2) and not c(1) and not c(0);
    s(5) <= not c(3) and c(2) and not c(1) and c(0);
    s(6) <= not c(3) and c(2) and c(1) and not c(0);
    s(7) <= not c(3) and c(2) and c(1) and c(0);
    s(8) <= c(3) and not c(2) and not c(1) and not c(0);
    s(9) <= c(3) and not c(2) and not c(1) and c(0);
end architecture rtl;
