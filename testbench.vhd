
library ieee;
use ieee.std_logic_1164.all;

entity testbench is
    -- a testbench has no ports
end entity testbench;

architecture behavior of testbench is
    component toplevel
        port (
            a, b, c : in  std_logic;
            clock   : in  std_logic;
            clear   : in  std_logic;
            p       : out std_logic_vector(0 to 6);
            c1, c2  : out std_logic
        );
    end component;
    for toplevel_0: toplevel use entity work.toplevel;
    signal a, b, c, clear, c1, c2 : std_logic;
    signal clock : std_logic := '0';
    signal p : std_logic_vector(0 to 6);

    constant clock_period : time := 10 ns;
begin
    toplevel_0: toplevel port map (
        a => a, b => b, c => c,
        clock => clock, clear => clear,
        p => p,
        c1 => c1,
        c2 => c2
    );
    clock_process : process
    begin
        clock <= '0';
        wait for clock_period / 8;
        clock <= '1';
        wait for clock_period / 8;
    end process;
    stim_process : process
        type pattern_type is record
            a, b, c, clear : std_logic;
            p : std_logic_vector(0 to 6);
            c1, c2 : std_logic;
        end record;
        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=
        (
            ('0', '0', '0', '0', "1000000", '0', '1'),
            ('0', '1', '0', '1', "0100000", '1', '0'),
            ('1', '0', '0', '1', "0010000", '0', '1'),
            ('0', '1', '0', '1', "0001000", '0', '0'),
            ('1', '0', '0', '1', "1000000", '0', '1'),
            ('0', '1', '0', '1', "0100000", '1', '0'),
            ('0', '0', '1', '1', "0000100", '0', '1'),
            ('0', '1', '0', '1', "0000010", '1', '0'),
            ('0', '0', '1', '1', "0000001", '1', '0'),
            ('1', '0', '0', '1', "1000000", '0', '1')
        );
    begin
        for i in patterns'range loop
            a <= patterns(i).a;
            b <= patterns(i).b;
            c <= patterns(i).c;
            clear <= patterns(i).clear;
            wait for clock_period;
            assert p = patterns(i).p
                report "bad p output" severity error;
            assert c1 = patterns(i).c1
                report "bad c1 output" severity error;
            assert c2 = patterns(i).c2
                report "bad c2 output" severity error;
        end loop;
        assert false report "end of test" severity note;
        wait;
    end process;
end architecture behavior;
