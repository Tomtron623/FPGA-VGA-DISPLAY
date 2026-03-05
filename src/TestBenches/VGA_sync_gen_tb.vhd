library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity VGA_sync_gen_tb is
end VGA_sync_gen_tb;

architecture TB of VGA_sync_gen_tb is
    component VGA_sync_gen
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        Hcount     : out std_logic_vector(9 downto 0);
        Vcount     : out std_logic_vector(9 downto 0);
        Horiz_Sync : out std_logic;
        Vert_Sync  : out std_logic;
        Video_On   : out std_logic
    );
    end component;

    signal clk_tb, rst_tb : std_logic := '0';
    signal Hcount_tb     : std_logic_vector(9 downto 0);
    signal Vcount_tb     : std_logic_vector(9 downto 0);
    signal Horiz_Sync_tb : std_logic;
    signal Vert_Sync_tb  : std_logic;
    signal Video_On_tb   : std_logic;

begin  -- TB

    UUT : VGA_sync_gen
    port map (
        clk        => clk_tb,
        rst        => rst_tb,
        Hcount     => Hcount_tb,
        Vcount     => Vcount_tb,
        Horiz_Sync => Horiz_Sync_tb,
        Vert_Sync  => Vert_Sync_tb,
        Video_On   => Video_On_tb
    );

    process
    begin
        wait for 20 ns;
        clk_tb <= not clk_tb;
    end process;
    process
    begin
        rst_tb <= '1';
        wait for 200 ns;
        rst_tb <= '0';

        wait for 17 ms;
        wait;
        report "Simulation Finished";
    end process;




end TB;
