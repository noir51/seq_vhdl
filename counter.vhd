-- includerea bibliotecilor std_logic si
-- std_logic_unsigned din ieee
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- entitatea numaratorului
entity counter is
    port (
        count, clock : in  std_logic;
        clear, load  : in  std_logic;
        d            : in  std_logic_vector(3 downto 0);
        q            : out std_logic_vector(3 downto 0)
    );
end entity counter;

-- arhitectura numaratorului
architecture rtl of counter is
    -- semnal intermediar
    signal tmp : std_logic_vector(3 downto 0);
begin
    process(clear, clock, count, load)
    begin
        -- resetare
        if clear = '0' then
            tmp <= "0000";
        -- front activ semnal de tact
        elsif clock'event and clock = '1' then
            -- incarcare paralela
            if load = '0' then
                tmp <= d;
            else
                -- incrementare
                if count = '1' then
                    tmp <= tmp + 1;
                end if;
            end if;
        end if;
    end process;
    q <= tmp;
end architecture rtl;
