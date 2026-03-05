library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity vga is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        switches         : in  std_logic_vector(3 downto 0);
        red, green, blue : out std_logic_vector(3 downto 0);
        h_sync, v_sync   : out std_logic
    );
end vga;

architecture str of vga is

    component clk_div
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            pixel_clk : out std_logic
        );
    end component;

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

    component row_addr_gen
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            Vcount   : in  std_logic_vector(9 downto 0);
            pos      : in  std_logic_vector(2 downto 0);
            Row_Addr : out std_logic_vector(5 downto 0);
            Row_en   : out std_logic
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

    signal clk_25        : std_logic;
    signal hcount_i      : std_logic_vector(9 downto 0);
    signal vcount_i      : std_logic_vector(9 downto 0);
    signal horiz_sync_i  : std_logic;
    signal vert_sync_i   : std_logic;
    signal video_on_i    : std_logic;

    signal row_addr_i    : std_logic_vector(5 downto 0);
    signal col_addr_i    : std_logic_vector(5 downto 0);
    signal row_en_i      : std_logic;
    signal col_en_i      : std_logic;

    signal rom_addr_i    : std_logic_vector(11 downto 0);
    signal rom_q_i       : std_logic_vector(11 downto 0);

    signal pos_i         : std_logic_vector(2 downto 0);

begin

    pos_i <= switches(2 downto 0);

    u_clkdiv : clk_div
        port map (
            clk       => clk,
            rst       => rst,
            pixel_clk => clk_25
        );

    u_sync : VGA_sync_gen
        port map (
            clk        => clk_25,
            rst        => rst,
            Hcount     => hcount_i,
            Vcount     => vcount_i,
            Horiz_Sync => horiz_sync_i,
            Vert_Sync  => vert_sync_i,
            Video_On   => video_on_i
        );

    u_col : col_addr_gen
        port map (
            clk      => clk_25,
            rst      => rst,
            Hcount   => hcount_i,
            pos      => pos_i,
            Col_Addr => col_addr_i,
            Col_en   => col_en_i
        );

    u_row : row_addr_gen
        port map (
            clk      => clk_25,
            rst      => rst,
            Vcount   => vcount_i,
            pos      => pos_i,
            Row_Addr => row_addr_i,
            Row_en   => row_en_i
        );

    rom_addr_i <= row_addr_i & col_addr_i;

    u_rom : vga_rom
        port map (
            address => rom_addr_i,
            clock   => clk_25,
            data    => (others => '0'),
            wren    => '0',
            q       => rom_q_i
        );

    h_sync <= horiz_sync_i;
    v_sync <= vert_sync_i;

    process(clk_25)
    begin
        if rising_edge(clk_25) then
            if video_on_i = '1' and row_en_i = '1' and col_en_i = '1' then
                red   <= rom_q_i(11 downto 8);
                green <= rom_q_i(7 downto 4);
                blue  <= rom_q_i(3 downto 0);
            else
                red   <= (others => '0');
                green <= (others => '0');
                blue  <= (others => '0');
            end if;
        end if;
    end process;

end str;