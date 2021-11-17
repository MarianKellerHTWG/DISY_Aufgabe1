
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
CONSTANT N_FT: natural := 16384;
SIGNAL cnt_ft: natural RANGE 0 to N_FT;
SIGNAL ft_en: std_logic : '0';

BEGIN

   -- Modulo-2**14-Zaehler
p_ft: PROCESS (rst, clk) IS
BEGIN
    IF rst='1' THEN
        cnt_ft <= 0;
    ELSIF rising_edge(clk) THEN
        IF cnt_ft=N_FT-1 THEN
            cnt_ft <= 0);
            ft_en <= not ft_en;
        ELSE
            cnt_ft <= cnt_ft + 1;
        END IF; 
    END IF;
END PROCESS;
   
   -- Modulo-4-Zaehler

   -- 1-aus-4-Dekoder als Phasengenerator
       
   -- 1-aus-4-Multiplexer

   -- 7-aus-4-Dekoder

   -- 1-aus-4-Multiplexer

END struktur;