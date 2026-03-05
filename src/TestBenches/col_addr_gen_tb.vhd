library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity col_addr_gen_tb is
end col_addr_gen_tb;

architecture tb of col_addr_gen_tb is

    component col_addr_gen
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            Hcount   : in  std_logic_vector(9 downto 0);
            pos      : in  std_logic_vector(2 downto 0);
            Col_Addr : out std_logic_vector(5 downto 0);
            Col_en   : out std_logic
        );
    end component;

    component vga_rom
        port (
            address : in  std_logic_vector(11 downto 0);
            clock   : in  std_logic;
            data    : in  std_logic_vector(11 downto 0);
            wren    : in  std_logic;
            q       : out std_logic_vector(11 downto 0)
        );
    end component;

    signal clk_tb    : std_logic := '0';
    signal rst_tb    : std_logic := '1';
    signal Hcount_tb : std_logic_vector(9 downto 0) := (others => '0');
    signal pos_tb    : std_logic_vector(2 downto 0) := "000";

    signal Col_Addr_tb : std_logic_vector(5 downto 0);
    signal Col_en_tb   : std_logic;

    signal rom_addr_tb : std_logic_vector(11 downto 0);
    signal rom_q_tb    : std_logic_vector(11 downto 0);

begin

    UUT: col_addr_gen
        port map (
            clk      => clk_tb,
            rst      => rst_tb,
            Hcount   => Hcount_tb,
            pos      => pos_tb,
            Col_Addr => Col_Addr_tb,
            Col_en   => Col_en_tb
        );

    ROM: vga_rom
        port map (
            address => rom_addr_tb,
            clock   => clk_tb,
            data    => (others => '0'),
            wren    => '0',
            q       => rom_q_tb
        );

    rom_addr_tb <= "000000" & Col_Addr_tb;

    clk_process : process
    begin
        clk_tb <= '0';
        wait for 20 ns;
        clk_tb <= '1';
        wait for 20 ns;
    end process;

    stim : process
    begin
        rst_tb <= '1';
        wait for 200 ns;
        rst_tb <= '0';

        for p in 0 to 4 loop
            pos_tb <= std_logic_vector(to_unsigned(p, 3));

            for i in 0 to 639 loop
                Hcount_tb <= std_logic_vector(to_unsigned(i, 10));
                wait for 40 ns;
            end loop;

            wait for 5 us;
        end loop;

        wait;
    end process;

end tb;
