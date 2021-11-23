
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY hex4x7seg IS
   GENERIC(RSTDEF: std_logic := '0');
   PORT(rst:   IN  std_logic;                       -- reset,           active RSTDEF
        clk:   IN  std_logic;                       -- clock,           rising edge
        data:  IN  std_logic_vector(15 DOWNTO 0);   -- data input,      active high
        dpin:  IN  std_logic_vector( 3 DOWNTO 0);   -- 4 decimal point, active high
        ena:   OUT std_logic_vector( 3 DOWNTO 0);   -- 4 digit enable  signals,                active high
        seg:   OUT std_logic_vector( 7 DOWNTO 1);   -- 7 connections to seven-segment display, active high
        dp:    OUT std_logic);                      -- decimal point output,                   active high
END hex4x7seg;

ARCHITECTURE struktur OF hex4x7seg IS
CONSTANT N_FD: natural := 16#FFF#;                  -- Frequency divider upper count
SIGNAL fd_cnt: natural RANGE 0 to N_FD;             -- Frequency divider counter
SIGNAL fd_out: std_logic := '0';                    -- Frequency divider output
SIGNAL cnt4_out: natural RANGE 0 to 3;              -- Mod 4 counter output
SIGNAL fourOf8Mux_out : std_logic_vector( 3 DOWNTO 0);


BEGIN

   -- Modulo-2**14-Zaehler und Modulo-4-Zaeler
    p_fd: PROCESS (rst, clk) IS
    BEGIN
        IF rst='1' THEN
            fd_cnt <= 0;
            cnt4_out <= 0;
        ELSIF rising_edge(clk) THEN
            IF fd_cnt=N_FD THEN
                fd_cnt <= 0;
                fd_out <= not fd_out;
                cnt4_out <= cnt4_out + 1;
            ELSE
                fd_cnt <= fd_cnt + 1;
            END IF; 
        END IF;
    END PROCESS;
   
    -- 1-aus-4-Dekoder als Phasengenerator
    oneOf4Decode: PROCESS (rst, cnt4_out)
    BEGIN
        IF rst='1' THEN
            ena <= "0000";
        END IF;
        CASE cnt4_out IS
            WHEN 0 => ena <= "0001";
            WHEN 1 => ena <= "0010";
            WHEN 2 => ena <= "0100";
            WHEN 3 => ena <= "1000";
            WHEN OTHERS => ena <= "0000";
        END CASE;
    END PROCESS;
       
   -- 1-aus-4-Multiplexer
   fourOf8Mux: PROCESS (cnt4_out)
    BEGIN
        CASE cnt4_out IS
            WHEN 0 => fourOf8Mux_out <= data (3 DOWNTO 0);
            WHEN 1 => fourOf8Mux_out <= data (7 DOWNTO 4);
            WHEN 2 => fourOf8Mux_out <= data (3 DOWNTO 0);
            WHEN 3 => fourOf8Mux_out <= data (7 DOWNTO 4);
            WHEN OTHERS => fourOf8Mux_out <= "0000";
        END CASE;
    END PROCESS;

   -- 1-aus-4-Multiplexer
   oneOf4Mux: PROCESS (cnt4_out)
    BEGIN
        CASE cnt4_out IS
            WHEN 0 => dp <= dpin(0);
            WHEN 1 => dp <= dpin(1);
            WHEN 2 => dp <= dpin(2);
            WHEN 3 => dp <= dpin(3);
            WHEN OTHERS => dp <= '0';
        END CASE;
    END PROCESS;

    -- 7-aus-4-Dekoder
    sevenOf4Decode: PROCESS (fourOf8Mux_out)
    BEGIN
        CASE fourOf8Mux_out IS
            WHEN 0 => seg <= "0111111";
            WHEN 1 => seg <= "0000110";
            WHEN 2 => seg <= "1011001";
            WHEN 3 => seg <= "1001111";
            WHEN 4 => seg <= "1100110";
            WHEN 5 => seg <= "1101101";
            WHEN 6 => seg <= "1111101";
            WHEN 7 => seg <= "0000111";
            WHEN 8 => seg <= "1111111";
            WHEN 9 => seg <= "1101111";
            WHEN 16#A# => seg <= "1110111";
            WHEN 16#B# => seg <= "1111100";
            WHEN 16#C# => seg <= "0111001";
            WHEN 16#D# => seg <= "1011110";
            WHEN 16#E# => seg <= "1111001";
            WHEN 16#F# => seg <= "1110001";
            WHEN OTHERS => seg <= "0000000";
        END CASE;
    END PROCESS;

END struktur;