library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity PtojetoFinal is 
	port
	(
		sys_clk: in std_logic;
		saida: out std_logic_vector( 6 downto 0); --display do timer 
		saida_leds : out std_logic_vector( 3 downto 0); --leds do contador de tempo binario
		botao : in std_logic; --botao de reset
		verde1: out std_logic;
		verde2: out std_logic;
		amarelo1: out std_logic;
		amarelo2: out std_logic;
		vermelho1: out std_logic;
		vermelho2: out std_logic;
		display_1: out std_logic_vector( 6 downto 0); -- G (go - vai) para semaforo de pedestres 1
		display_2: out std_logic_vector( 6 downto 0); -- P (pare) para semaforo de pedestres 1
		display_3: out std_logic_vector( 6 downto 0); -- G (go - vai) para semaforo de pedestres 2
		display_4: out std_logic_vector( 6 downto 0) -- P (pare) para semaforo de pedestres 2
		
	);
end ProjetoFinal;	

-- Frequencia de 50Mhz no clock 50*10^6

architecture Semaforo of ProjetoFinal is

constant clock_free : integer := 50e6;
signal ticks : integer := 0;
signal segundos: integer := 0;
signal cont_leds : std_logic_vector (3 downto 0);
signal aux : integer := 5; --timer que vai decrementar para cada luz

begin
	
	process (sys_clk) is
	begin
	
		if rising_edge(sys_clk) then
			if ticks = clock_free - 1 then
				ticks <= 0;
				if segundos = 0 then 
					--semaforo1
					verde1 <= '1';
					amarelo1 <= '0';
					vermelho1<= '0';
					--semaforo 2
					verde2 <= '0';
					amarelo2 <= '0';
					vermelho2<= '1';
					aux <= 5;
					segundos <= segundos + 1;
					
				elsif segundos = 5 then
					--semaforo1
					verde1 <= '0';
					amarelo1 <= '1';
					vermelho1<= '0';
					--semaforo 2
					verde2 <= '0';
					amarelo2 <= '0';
					vermelho2<= '1';
					aux <= 5;
					segundos <= segundos + 1;
					
				elsif segundos = 10 then 
					--semaforo1
					verde1 <= '0';
					amarelo1 <= '0';
					vermelho1<= '1';
					--semaforo 2
					verde2 <= '1';
					amarelo2 <= '0';
					vermelho2<= '0';
					aux <= 5;
					segundos <= segundos + 1;
					
				elsif segundos = 15 then 
					--semaforo1
					verde1 <= '0';
					amarelo1 <= '0';
					vermelho1<= '1';
					--semaforo 2
					verde2 <= '0';
					amarelo2 <= '1';
					vermelho2<= '0';
					aux <= 5;
					segundos <= segundos + 1;
					
				elsif segundos = 20 then 
					segundos <= 0;
					aux <= 5;
					
				else
					segundos <= segundos + 1;
					aux <= aux - 1;
				end if;
			else
				ticks <= ticks + 1;
			end if;
		end if;
		
	if botao = '0' then
		ticks <= 0;
		aux <= 5;
		segundos <= 0;
	end if;
	
	cont_leds <= conv_std_logic_vector(segundos,4);	
	end process;
	--        6543210
	saida <= "1000000" when aux = 0 else
				"1111001" when aux = 1 else
				"0100100" when aux = 2 else
            "0110000" when aux = 3 else	
				"0011001" when aux = 4 else
				"0010010" when aux = 5;
				
	saida_leds <= cont_leds;
	--            6543210
	display_1 <= "0000010" when segundos > 10 AND segundos <= 20 else
					 "1111111" when segundos > 0 AND segundos <= 10 ;
				
	display_2 <= "1111111" when segundos > 10 AND segundos <= 20 else
				    "0001100" when segundos > 0 AND segundos <= 10;
				
	display_3 <= "0000010" when segundos > 0 AND segundos <= 10 else
					 "1111111" when segundos > 10 AND segundos <= 20;
				
	display_4 <= "1111111" when segundos > 0 AND segundos <= 10 else
				    "0001100" when segundos > 10 AND segundos <= 20;
	
end Semaforo;
