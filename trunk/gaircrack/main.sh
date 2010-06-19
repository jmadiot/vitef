#! /bin/bash
 
# main window to select the interface. 
export MAIN_DIALOG='
<vbox>
	<text>
		<label>Please enter a device name.</label>
	</text>
	<hbox>
	<entry>
		<variable>DEVICE</variable>
		<default>wlan0</default>	
	</entry>
	<text>
		<label>capture files</label>
	</text>
	<entry>
		<variable>CAP</variable>
		<default>capture</default>	
	</entry>
	
	<button ok>
		<action>airmon-ng start $DEVICE > /dev/null; xterm -rv -e "airodump-ng mon0 -w $CAP" &  gtkdialog --program=CRACK_DIALOG &</action>
	</button>
	<button cancel></button>
	</hbox>
</vbox>'
 
 
# window to select the network to crack 
export CRACK_DIALOG='
<vbox>
	<text>
		<label>Please enter the name of the target network (ESSID) when you have enough data.</label>
	</text>
	<hbox>
	<entry>
		<variable>TARGET</variable>
	</entry>	
	<button ok>
		<action>xterm -rv -e "aircrack-ng -e "$TARGET" $CAP*.cap" &</action>
	</button>
	<button cancel></button>
	</hbox>
</vbox>'

 
 
gtkdialog --program=MAIN_DIALOG
