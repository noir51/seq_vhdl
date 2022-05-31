-- includem biblioteca std_logic_vector din ieee
library ieee;
use ieee.std_logic_1164.all;

-- intrarile si iesirile entitatii de nivel superior
entity toplevel is
    port (
        a, b, c : in  std_logic;
        clock   : in  std_logic;
        clear   : in  std_logic;
        p       : out std_logic_vector(0 to 6);
        c1, c2  : out std_logic
    );
end entity toplevel;

-- arhitectura rtl a entitatii de nivel superior
architecture rtl of toplevel is
    -- componentele arhitecturii ce urmeaza a fi inregistrate
    -- | decodificator BCD
    component decoder is
        port (
            c : in  std_logic_vector(3 downto 0);
            s : out std_logic_vector(0 to 9)
        );
    end component decoder;
    -- | numarator binar
    component counter is
        port (
            count, clock : in  std_logic;
            clear, load  : in  std_logic;
            d            : in  std_logic_vector(3 downto 0);
            q            : out std_logic_vector(3 downto 0)
        );
    end component counter;
    -- | multiplexor 8:1
    component mux81 is
        port (
            d   : in  std_logic_vector(0 to 7);
            sel : in  std_logic_vector(0 to 2);
            o   : out std_logic
        );
    end component mux81;
    -- alocarea semnalelor intermediare pentru fiecare componenta inregistrata
    -- | decodificator
    signal q_code           : std_logic_vector(3 downto 0);
    signal d_code           : std_logic_vector(0 to 9);
    -- | numarator binar
    signal c_count, c_clock : std_logic;
    signal c_clear, c_load  : std_logic;
    signal cd, cq           : std_logic_vector(3 downto 0);
    -- | multiplexoarele 8:1 pentru COUNT si LOAD
    signal md_load          : std_logic_vector(0 to 7);
    signal md_count         : std_logic_vector(0 to 7);
    signal m_sel            : std_logic_vector(0 to 2);
    signal m_load           : std_logic;
    signal m_count          : std_logic;
    -- | semnal intermediar pentru iesirile circuitului
    signal x                : std_logic_vector(0 to 6);
begin
    -- inregistrarea decodificatorului
    u_decoder : component decoder
        port map (
            c => q_code,
            s => d_code
        );
    -- inregistrarea numaratorului
    u_counter : component counter
        port map (
            count => c_count,
            clock => c_clock,
            clear => c_clear,
            load  => c_load,
            d     => cd,
            q     => cq
        );

    -- bloc de proces pentru semnalele COUNT si LOAD
    process(clock)
    begin
        -- front activ al semnalului de tact
        if clock'event and clock = '1' then
            -- atribuirea semnalelor COUNT si LOAD
            c_count <= m_count;
            c_load  <= not m_load;
        end if;
    end process;

    -- liniile de incarcare paralela ale numaratorului
    cd <= (
        2      => x(1),
        others => '0'
    );

    -- atribuirea semnalului de initializare si de tact
    c_clock <= clock;
    c_clear <= clear;

    -- multiplexorul pentru semnalul de COUNT cu porturile alocate
    u_muxcount : component mux81
        port map (
            d   => md_count,
            sel => m_sel,
            o   => m_count
        );
    -- multiplexorul pentru semnalul de LOAD cu porturile alocate
    u_muxload : component mux81
        port map (
            d   => md_load,
            sel => m_sel,
            o   => m_load
        );

    -- atribuirea intrarilor de selectie ale multiplexoarelor
    m_sel <= (
        2 => cq(0),
        1 => cq(1),
        0 => cq(2)
    );
    -- atribuirea intrarilor de decizie pentru multiplexorul COUNT
    md_count <= (
        0      => b,
        1      => a,
        2      => b,
        4      => b,
        5      => c,
        others => '0'
    );
    -- atribuirea intrarilor de decizie pentru multiplexorul LOAD
    md_load <= (
        1      => c,
        3      => a,
        6      => a,
        others => '0'
    );

    -- atribuirea intrarilor decodif. la iesirile numaratorului
    q_code(3) <= '0';
    q_code(2 downto 0) <= cq(2 downto 0);

    -- atribuirea iesirilor circuitului la iesirile decodif.
    x <= d_code(0 to 6);
    -- iesirile c1 si c2
    c1 <= x(1) or x(5) or x(6);
    c2 <= x(0) or x(2) or x(4);

    -- semnal intermediar x la iesirile p
    p(0 to 6) <= x;
end architecture rtl;
