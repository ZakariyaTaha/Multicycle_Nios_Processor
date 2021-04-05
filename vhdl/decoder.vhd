library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_buttons : out std_logic ;
        cs_ROM  : out std_logic
    );
end decoder;

architecture synth of decoder is
begin
	process(address) 
	begin
		if(unsigned(address) >= x"0000" and unsigned(address) <= x"0FFC" ) then cs_ROM <= '1' ; cs_RAM <= '0' ; cs_LEDS <= '0' ;cs_buttons <='0' ;
        elsif(unsigned(address) >= x"1000" and unsigned(address) <= x"1FFC" ) then cs_ROM <= '0' ; cs_RAM <= '1' ; cs_LEDS <= '0' ;cs_buttons <='0' ;
        elsif(unsigned(address) >= x"2000" and unsigned(address) <= x"200C" ) then cs_ROM <= '0' ; cs_RAM <= '0' ; cs_LEDS <= '1' ;cs_buttons <='0' ;
        elsif(unsigned(address) >= x"2030" and unsigned(address) <= x"2034" ) then cs_ROM <= '0' ; cs_RAM <= '0' ; cs_LEDS <= '0' ;cs_buttons <='1' ;
        else cs_ROM <= '0' ; cs_RAM <= '0' ; cs_LEDS <= '0' ; cs_buttons <='0' ;

    end if ;


	end process ;
end synth;