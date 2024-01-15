# Six_Instruction_Programmable_Processor

~~ Code files include each individual module with the overall processor titled Processor.sv ~~

https://youtu.be/tIYzPfKDKeE

# Overall Explanation of Project

HEX3, 2, 1, and 0 always display the current contents of the Instruction Register
▪ SW[17:15] determines what HEX 7, 6, 5, and 4 display as follows:
▪ 0 => HEX7, HEX6 = PC; HEX5, HEX4 = Current State
▪ 1 => HEX7, 6, 5, 4 = ALU_A (A-side input to ALU)
▪ 2 => HEX7, 6, 5, 4 = ALU_B (B-side input to ALU)
▪ 3 => HEX7, 6, 5, 4 = ALU_Out (ALU output)
▪ 4 => Next State (FSM next state variable)

• The following sample program compiled and loaded into Instruction Memory:
RF[0A] = D[1B] - D[2A] + D[3C] - D[7E]
D[6A] = RF[0A]
HALT

Which translates to:
load D1B - 2 1b 0
load D2A - 2 2a 1
load D3C - 2 3c 2
load D7E - 2 7e 3

sub (D1B - D2A) - 4 0 1 4
add (result + d3c) - 3 4 2 5
sub (result - 7e)- 4 5 3 a

Store - 1 a 6a
Halt - 5 000

Data memory should initially contain
D[1B] = 0x21BA
D[2A] = 0xA04E
D[3C] = 0x71AC
D[7E] = 0xB17F
