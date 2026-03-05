--Name: Tomas Martinez Anderson
--Description: VGA sync generator (Use with 25Mhz clk)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity VGA_sync_gen is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        Hcount     : out std_logic_vector(9 downto 0);
        Vcount     : out std_logic_vector(9 downto 0);
        Horiz_Sync : out std_logic;
        Vert_Sync  : out std_logic;
        Video_On   : out std_logic
    );
end VGA_sync_gen;

architecture bhv of VGA_sync_gen is

    signal countH, countV : unsigned(9 downto 0) := (others => '0');
    signal Horiz_Sync1, Vert_Sync1, Video_On1 : std_logic := '0';

begin
    Hcount <= std_logic_vector(countH);
    Vcount <= std_logic_vector(countV);
    Horiz_Sync <= not Horiz_Sync1;
    Vert_Sync <= not Vert_Sync1;
    Video_On <= Video_On1;

    --All counters in one structure
    process(clk, rst)
    begin
        if rst = '1' then
            countH      <= (others => '0');
            countV      <= (others => '0');
            Horiz_Sync1 <= '0';
            Vert_Sync1  <= '0';
            Video_On1   <= '0';

        elsif rising_edge(clk) then

            -- HORIZONTAL COUNTER
            if countH = H_MAX then
                countH <= (others => '0');
            else
                countH <= countH + 1;
            end if;

            -- VERTICAL COUNTER (increments once per line)

            if countH = H_VERT_INC then
                if countV = V_MAX then
                    countV <= (others => '0');
                else
                    countV <= countV + 1;
                end if;
            end if;

            -- HORIZONTAL SYNC
            if countH = HSYNC_BEGIN then
                Horiz_Sync1 <= '1';
            end if;

            if countH = HSYNC_END then
                Horiz_Sync1 <= '0';
            end if;

            -- VERTICAL SYNC
            if countV = VSYNC_BEGIN then
                if countH = H_VERT_INC then
                    Vert_Sync1 <= '1';
                end if;
            end if;

            if countV = VSYNC_END then
                if countH = H_VERT_INC then
                    Vert_Sync1 <= '0';
                end if;
            end if;

            -- VIDEO ON
            if countH <= H_DISPLAY_END then
                if countV <= V_DISPLAY_END then
                    Video_On1 <= '1';
                end if;
            end if;

            if countH > H_DISPLAY_END then
                Video_On1 <= '0';
            end if;

            if countV > V_DISPLAY_END then
                Video_On1 <= '0';
            end if;

        end if;
    end process;

end bhv;